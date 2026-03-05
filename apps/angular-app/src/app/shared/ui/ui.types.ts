// Types partagés — composants UI Learn@Home
// Utilisés par tous les composants de src/app/shared/ui/

export type ButtonVariant = 'primary' | 'secondary' | 'ghost' | 'danger';

export type ButtonSize = 'sm' | 'md' | 'lg';

export type TaskStatus = 'todo' | 'in_progress' | 'done' | 'late';

export const TASK_STATUS_LABELS: Record<TaskStatus, string> = {
  todo: 'À faire',
  in_progress: 'En cours',
  done: 'Terminé',
  late: 'En retard',
} as const;

export type AvatarSize = 24 | 32 | 40 | 48;

export type ToastType = 'success' | 'error' | 'warning' | 'info';

export type ToastData = {
  message: string;
  type: ToastType;
  duration?: number;
};

export type NavItem = {
  label: string;
  route: string;
  icon: string;
  badge?: number;
};

export type TaskItem = {
  id: string;
  title: string;
  status: TaskStatus;
  assignedTo?: string;
  dueDate?: string;
};

export type MessageSide = 'me' | 'other';

export type ModalSize = 'sm' | 'md' | 'lg';

export type ModalConfig<T = unknown> = {
  title: string;
  size?: ModalSize;
  data?: T;
};
