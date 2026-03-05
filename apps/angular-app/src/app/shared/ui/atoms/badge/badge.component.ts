import { ChangeDetectionStrategy, Component, computed, input } from '@angular/core';
import { TASK_STATUS_LABELS, type TaskStatus } from '../../ui.types';

@Component({
  selector: 'app-badge',
  standalone: true,
  templateUrl: './badge.component.html',
  styleUrl: './badge.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class BadgeComponent {
  status = input.required<TaskStatus>();

  protected label = computed(() => TASK_STATUS_LABELS[this.status()]);
}
