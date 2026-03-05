import {
  ChangeDetectionStrategy,
  Component,
  computed,
  input,
  output,
} from '@angular/core';
import { MatTooltipModule } from '@angular/material/tooltip';
import { LucideAngularModule, Bell, Search, ChevronLeft } from 'lucide-angular';
import { AvatarComponent } from '../../atoms/avatar/avatar.component';

@Component({
  selector: 'app-top-app-bar',
  standalone: true,
  imports: [MatTooltipModule, LucideAngularModule, AvatarComponent],
  templateUrl: './top-app-bar.component.html',
  styleUrl: './top-app-bar.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class TopAppBarComponent {
  pageTitle = input<string>('');
  showBackButton = input<boolean>(false);
  showSearch = input<boolean>(false);
  notificationCount = input<number>(0);
  userPhotoUrl = input<string | undefined>(undefined);
  userInitials = input<string>('?');

  backClick = output<void>();
  searchClick = output<void>();
  notificationClick = output<void>();
  avatarClick = output<void>();

  protected readonly BellIcon = Bell;
  protected readonly SearchIcon = Search;
  protected readonly BackIcon = ChevronLeft;

  protected hasNotifications = computed(() => this.notificationCount() > 0);

  protected notificationLabel = computed(() => {
    const count = this.notificationCount();
    if (count === 0) return 'Notifications';
    return `${count} notification${count > 1 ? 's' : ''} non lue${count > 1 ? 's' : ''}`;
  });

  protected notificationBadge = computed(() => {
    const count = this.notificationCount();
    return count > 99 ? '99+' : count.toString();
  });
}
