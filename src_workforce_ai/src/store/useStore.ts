import { create } from 'zustand'
import { Worker, Department, Company, Template } from '@/types'

interface AppState {
  company: Company | null
  workers: Worker[]
  departments: Department[]
  templates: Template[]

  setCompany: (company: Company) => void
  setWorkers: (workers: Worker[]) => void
  addWorker: (worker: Worker) => void
  updateWorker: (id: string, updates: Partial<Worker>) => void
  deleteWorker: (id: string) => void

  setDepartments: (departments: Department[]) => void
  addDepartment: (department: Department) => void
  updateDepartment: (id: string, updates: Partial<Department>) => void
  deleteDepartment: (id: string) => void

  setTemplates: (templates: Template[]) => void
}

export const useStore = create<AppState>((set) => ({
  company: {
    id: '1',
    name: 'Acme Corp',
    plan: 'pro',
    workerCount: 24,
    executionCount: 15420,
    departmentCount: 5,
    createdAt: '2024-01-15',
  },
  workers: [],
  departments: [],
  templates: [],

  setCompany: (company) => set({ company }),

  setWorkers: (workers) => set({ workers }),
  addWorker: (worker) => set((state) => ({
    workers: [...state.workers, worker]
  })),
  updateWorker: (id, updates) => set((state) => ({
    workers: state.workers.map((w) =>
      w.id === id ? { ...w, ...updates } : w
    ),
  })),
  deleteWorker: (id) => set((state) => ({
    workers: state.workers.filter((w) => w.id !== id),
  })),

  setDepartments: (departments) => set({ departments }),
  addDepartment: (department) => set((state) => ({
    departments: [...state.departments, department],
  })),
  updateDepartment: (id, updates) => set((state) => ({
    departments: state.departments.map((d) =>
      d.id === id ? { ...d, ...updates } : d
    ),
  })),
  deleteDepartment: (id) => set((state) => ({
    departments: state.departments.filter((d) => d.id !== id),
  })),

  setTemplates: (templates) => set({ templates }),
}))
