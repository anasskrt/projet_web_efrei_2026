import {
  ChangeDetectionStrategy,
  Component,
  computed,
  inject,
  input,
  output,
} from '@angular/core';
import { DatePipe } from '@angular/common';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatTooltipModule } from '@angular/material/tooltip';
import { LucideAngularModule, Pencil, Trash2 } from 'lucide-angular';
import { BadgeComponent } from '../../atoms/badge/badge.component';
import type { TaskItem, TaskStatus } from '../../ui.types';

@Component({
  selector: 'app-task-item',
  standalone: true,
  imports: [
    DatePipe,
    MatCheckboxModule,
    MatTooltipModule,
    LucideAngularModule,
    BadgeComponent,
  ],
  templateUrl: './task-item.component.html',
  styleUrl: './task-item.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class TaskItemComponent {
  task = input.required<TaskItem>();
  canEdit = input<boolean>(false);

  statusChange = output<{ id: string; status: TaskStatus }>();
  editTask = output<string>();
  deleteTask = output<string>();

  protected readonly PencilIcon = Pencil;
  protected readonly Trash2Icon = Trash2;

  protected isDone = computed(() => this.task().status === 'done');
  protected isLate = computed(() => this.task().status === 'late');

  protected onCheck(checked: boolean): void {
    this.statusChange.emit({
      id: this.task().id,
      status: checked ? 'done' : 'todo',
    });
  }

  protected onEdit(): void {
    this.editTask.emit(this.task().id);
  }

  protected onDelete(): void {
    this.deleteTask.emit(this.task().id);
  }
}
