import { ChangeDetectionStrategy, Component, input } from '@angular/core';
import { MatDividerModule } from '@angular/material/divider';

@Component({
  selector: 'app-divider',
  standalone: true,
  imports: [MatDividerModule],
  template: `<mat-divider [vertical]="vertical()" />`,
  styleUrl: './divider.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class DividerComponent {
  vertical = input<boolean>(false);
}
