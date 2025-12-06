/**
 * n8n Integration Service
 * Handles all communication with n8n workflow engine
 */

import { WorkerType } from "@prisma/client";

// n8n Configuration
const N8N_API_URL = process.env.N8N_API_URL || "http://localhost:5678";
const N8N_API_KEY = process.env.N8N_API_KEY;

if (!N8N_API_KEY) {
  console.warn("N8N_API_KEY not configured. n8n integration will fail.");
}

// Types for n8n API responses
export interface N8nWorkflow {
  id: string;
  name: string;
  active: boolean;
  nodes: any[];
  connections: any;
  settings?: any;
  staticData?: any;
  tags?: string[];
  versionId?: string;
}

export interface N8nExecution {
  id: string;
  finished: boolean;
  mode: "manual" | "trigger" | "webhook";
  startedAt: Date;
  stoppedAt?: Date;
  workflowId: string;
  data: {
    resultData: {
      runData: any;
    };
  };
}

export interface EnhancePromptResponse {
  enhancedPrompt: string;
  suggestedName: string;
  suggestedType: WorkerType;
  requiredIntegrations: string[];
  estimatedComplexity: "low" | "medium" | "high";
}

export interface CreateWorkflowResponse {
  workflowId: string;
  workflowName: string;
  nodes: number;
  active: boolean;
}

export interface ExecuteWorkflowResponse {
  executionId: string;
  status: "running" | "success" | "failed";
  data?: any;
  error?: string;
}

/**
 * n8n Service Class
 */
export class N8nService {
  private apiUrl: string;
  private apiKey: string;

  constructor() {
    this.apiUrl = N8N_API_URL;
    this.apiKey = N8N_API_KEY || "";
  }

  /**
   * Make authenticated request to n8n API
   */
  private async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<T> {
    const url = `${this.apiUrl}/api/v1${endpoint}`;

    const headers = {
      "Content-Type": "application/json",
      "X-N8N-API-KEY": this.apiKey,
      ...options.headers,
    };

    const response = await fetch(url, {
      ...options,
      headers,
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(
        `n8n API error (${response.status}): ${error}`
      );
    }

    return response.json();
  }

  /**
   * Step 1: Enhance user prompt using n8n workflow
   * Calls the "enhance-prompt" workflow
   */
  async enhancePrompt(
    originalPrompt: string
  ): Promise<EnhancePromptResponse> {
    try {
      // Execute the enhance-prompt workflow
      const result = await this.executeWorkflowByName("enhance-prompt", {
        prompt: originalPrompt,
      });

      // Parse the response from the workflow
      return {
        enhancedPrompt: result.enhancedPrompt || originalPrompt,
        suggestedName: result.suggestedName || "Unnamed Worker",
        suggestedType: result.suggestedType || WorkerType.CUSTOM,
        requiredIntegrations: result.requiredIntegrations || [],
        estimatedComplexity: result.estimatedComplexity || "medium",
      };
    } catch (error) {
      console.error("Failed to enhance prompt:", error);
      // Return fallback response
      return {
        enhancedPrompt: originalPrompt,
        suggestedName: "Custom Worker",
        suggestedType: WorkerType.CUSTOM,
        requiredIntegrations: [],
        estimatedComplexity: "medium",
      };
    }
  }

  /**
   * Step 2: Create n8n workflow from enhanced prompt
   * Calls the "create-workflow" workflow
   */
  async createWorkflow(
    enhancedPrompt: string,
    workerName: string,
    workerType: WorkerType
  ): Promise<CreateWorkflowResponse> {
    try {
      // Execute the create-workflow workflow
      const result = await this.executeWorkflowByName("create-workflow", {
        enhancedPrompt,
        workerName,
        workerType,
      });

      return {
        workflowId: result.workflowId,
        workflowName: result.workflowName || workerName,
        nodes: result.nodes || 0,
        active: false, // Start inactive
      };
    } catch (error) {
      console.error("Failed to create workflow:", error);
      throw new Error("Failed to create n8n workflow");
    }
  }

  /**
   * Execute a workflow by name
   */
  async executeWorkflowByName(
    workflowName: string,
    data: any
  ): Promise<any> {
    // First, find the workflow by name
    const workflows = await this.request<{ data: N8nWorkflow[] }>(
      "/workflows"
    );
    const workflow = workflows.data.find((w) => w.name === workflowName);

    if (!workflow) {
      throw new Error(`Workflow "${workflowName}" not found`);
    }

    // Execute the workflow
    return this.executeWorkflow(workflow.id, data);
  }

  /**
   * Execute a workflow by ID
   */
  async executeWorkflow(workflowId: string, data: any): Promise<any> {
    const result = await this.request<N8nExecution>(
      `/workflows/${workflowId}/execute`,
      {
        method: "POST",
        body: JSON.stringify({ data }),
      }
    );

    // Wait for execution to complete (with timeout)
    const executionResult = await this.waitForExecution(
      result.id,
      30000 // 30 second timeout
    );

    if (!executionResult.finished) {
      throw new Error("Workflow execution timeout");
    }

    // Extract the result data
    return executionResult.data?.resultData?.runData || {};
  }

  /**
   * Wait for workflow execution to complete
   */
  private async waitForExecution(
    executionId: string,
    timeout: number = 30000
  ): Promise<N8nExecution> {
    const startTime = Date.now();
    const pollInterval = 1000; // 1 second

    while (Date.now() - startTime < timeout) {
      const execution = await this.getExecution(executionId);

      if (execution.finished) {
        return execution;
      }

      // Wait before polling again
      await new Promise((resolve) => setTimeout(resolve, pollInterval));
    }

    throw new Error("Execution timeout");
  }

  /**
   * Get execution status
   */
  async getExecution(executionId: string): Promise<N8nExecution> {
    return this.request<N8nExecution>(`/executions/${executionId}`);
  }

  /**
   * Get workflow by ID
   */
  async getWorkflow(workflowId: string): Promise<N8nWorkflow> {
    return this.request<N8nWorkflow>(`/workflows/${workflowId}`);
  }

  /**
   * Activate/Deactivate workflow
   */
  async setWorkflowActive(
    workflowId: string,
    active: boolean
  ): Promise<N8nWorkflow> {
    const workflow = await this.getWorkflow(workflowId);

    return this.request<N8nWorkflow>(`/workflows/${workflowId}`, {
      method: "PATCH",
      body: JSON.stringify({
        ...workflow,
        active,
      }),
    });
  }

  /**
   * Delete workflow
   */
  async deleteWorkflow(workflowId: string): Promise<void> {
    await this.request(`/workflows/${workflowId}`, {
      method: "DELETE",
    });
  }

  /**
   * List all workflows
   */
  async listWorkflows(): Promise<N8nWorkflow[]> {
    const response = await this.request<{ data: N8nWorkflow[] }>(
      "/workflows"
    );
    return response.data;
  }

  /**
   * List workflow executions
   */
  async listExecutions(workflowId?: string): Promise<N8nExecution[]> {
    const endpoint = workflowId
      ? `/executions?workflowId=${workflowId}`
      : "/executions";

    const response = await this.request<{ data: N8nExecution[] }>(endpoint);
    return response.data;
  }

  /**
   * Health check
   */
  async healthCheck(): Promise<boolean> {
    try {
      await this.request("/workflows");
      return true;
    } catch (error) {
      console.error("n8n health check failed:", error);
      return false;
    }
  }
}

// Singleton instance
export const n8nService = new N8nService();

// Helper functions
export async function enhanceWorkerPrompt(
  prompt: string
): Promise<EnhancePromptResponse> {
  return n8nService.enhancePrompt(prompt);
}

export async function createWorkerWorkflow(
  enhancedPrompt: string,
  name: string,
  type: WorkerType
): Promise<CreateWorkflowResponse> {
  return n8nService.createWorkflow(enhancedPrompt, name, type);
}

export async function deployWorker(workflowId: string): Promise<void> {
  await n8nService.setWorkflowActive(workflowId, true);
}

export async function pauseWorker(workflowId: string): Promise<void> {
  await n8nService.setWorkflowActive(workflowId, false);
}

export async function executeWorker(
  workflowId: string,
  input: any
): Promise<ExecuteWorkflowResponse> {
  try {
    const execution = await n8nService.executeWorkflow(workflowId, input);

    return {
      executionId: execution.id,
      status: "success",
      data: execution.data,
    };
  } catch (error: any) {
    return {
      executionId: "",
      status: "failed",
      error: error.message,
    };
  }
}
