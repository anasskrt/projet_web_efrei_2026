import { ChangeDetectionStrategy, Component, computed, input } from '@angular/core';
import { LucideAngularModule, MessageCircle } from 'lucide-angular';
import { CardComponent } from '../../../../shared/ui/molecules/card/card.component';
import { AvatarComponent } from '../../../../shared/ui/atoms/avatar/avatar.component';
import type { DashboardUnreadMessage } from '../../models/dashboard.models';

@Component({
  selector: 'app-messages-card',
  standalone: true,
  imports: [CardComponent, LucideAngularModule, AvatarComponent],
  templateUrl: './messages-card.component.html',
  styleUrl: './messages-card.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class MessagesCardComponent {
  messages = input<DashboardUnreadMessage[] | null>(null);

  protected readonly MessageCircleIcon = MessageCircle;

  protected readonly isLoading = computed(() => this.messages() === null);
  protected readonly hasMessages = computed(() => (this.messages()?.length ?? 0) > 0);

  protected getInitial(name: string): string {
    return name.trim().length > 0 ? name.trim()[0].toUpperCase() : '?';
  }
}
