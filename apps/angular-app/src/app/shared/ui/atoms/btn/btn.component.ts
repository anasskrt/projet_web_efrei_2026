import {
  ChangeDetectionStrategy,
  Component,
  input,
  output,
} from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { LucideAngularModule, type LucideIconData } from 'lucide-angular';
import type { ButtonSize, ButtonVariant } from '../../ui.types';

@Component({
  selector: 'app-btn',
  standalone: true,
  imports: [MatButtonModule, MatProgressSpinnerModule, LucideAngularModule],
  templateUrl: './btn.component.html',
  styleUrl: './btn.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class BtnComponent {
  variant = input<ButtonVariant>('primary');
  size = input<ButtonSize>('md');
  loading = input<boolean>(false);
  disabled = input<boolean>(false);
  icon = input<LucideIconData | undefined>(undefined);
  type = input<'button' | 'submit' | 'reset'>('button');

  btnClick = output<MouseEvent>();

  protected get isDisabled(): boolean {
    return this.disabled() || this.loading();
  }

  protected get iconSize(): number {
    const sizes: Record<ButtonSize, number> = { sm: 14, md: 16, lg: 18 };
    return sizes[this.size()];
  }

  protected onClick(event: MouseEvent): void {
    if (!this.isDisabled) {
      this.btnClick.emit(event);
    }
  }
}
