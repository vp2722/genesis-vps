export interface Worker {
  id: string
  name: string
  description: string
  department: string
  status: 'active' | 'inactive' | 'draft'
  nodes: WorkerNode[]
  edges: WorkerEdge[]
  createdAt: string
  updatedAt: string
  executionCount: number
  lastExecuted?: string
}

export interface WorkerNode {
  id: string
  type: 'trigger' | 'action' | 'condition' | 'loop'
  position: { x: number; y: number }
  data: {
    label: string
    config: Record<string, any>
  }
}

export interface WorkerEdge {
  id: string
  source: string
  target: string
  sourceHandle?: string
  targetHandle?: string
}

export interface Department {
  id: string
  name: string
  description: string
  workerCount: number
  color: string
  createdAt: string
}

export interface Company {
  id: string
  name: string
  plan: 'free' | 'pro' | 'enterprise'
  workerCount: number
  executionCount: number
  departmentCount: number
  createdAt: string
}

export interface ExecutionStats {
  date: string
  executions: number
  successes: number
  failures: number
}

export interface Template {
  id: string
  name: string
  description: string
  category: string
  nodes: WorkerNode[]
  edges: WorkerEdge[]
  featured: boolean
  usageCount: number
}

export interface User {
  id: string
  name: string
  email: string
  role: 'admin' | 'user'
  avatar?: string
}
