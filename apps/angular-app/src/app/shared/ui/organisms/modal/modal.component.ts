import {
  ChangeDetectionStrategy,
  Component,
  input,
  output,
} from '@angular/core';
import { LucideAngularModule, X } from 'lucide-angular';
import type { ModalSize } from '../../ui.types';

@Component({
  selector: 'app-modal',
  standalone: true,
  imports: [LucideAngularModule],
  templateUrl: './modal.component.html',
  styleUrl: './modal.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ModalComponent {
  title = input<string>('');
  size = input<ModalSize>('md');
  showClose = input<boolean>(true);

  closeModal = output<void>();

  protected readonly CloseIcon = X;
}
