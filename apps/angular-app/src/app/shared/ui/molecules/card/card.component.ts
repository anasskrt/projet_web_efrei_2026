import {
  ChangeDetectionStrategy,
  Component,
  input,
  output,
} from '@angular/core';

export type CardVariant = 'elevated' | 'flat';

@Component({
  selector: 'app-card',
  standalone: true,
  templateUrl: './card.component.html',
  styleUrl: './card.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class CardComponent {
  variant = input<CardVariant>('elevated');
  clickable = input<boolean>(false);
  noPadding = input<boolean>(false);

  cardClick = output<MouseEvent>();

  protected onClick(event: MouseEvent): void {
    if (this.clickable()) {
      this.cardClick.emit(event);
    }
  }
}
