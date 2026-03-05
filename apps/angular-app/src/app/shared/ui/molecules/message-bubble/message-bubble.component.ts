import { ChangeDetectionStrategy, Component, computed, input } from '@angular/core';
import { DatePipe } from '@angular/common';
import type { MessageSide } from '../../ui.types';

@Component({
  selector: 'app-message-bubble',
  standalone: true,
  imports: [DatePipe],
  templateUrl: './message-bubble.component.html',
  styleUrl: './message-bubble.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class MessageBubbleComponent {
  side = input.required<MessageSide>();
  message = input.required<string>();
  sentAt = input<Date | string | null>(null);
  senderName = input<string | undefined>(undefined);

  protected isMe = computed(() => this.side() === 'me');
}
