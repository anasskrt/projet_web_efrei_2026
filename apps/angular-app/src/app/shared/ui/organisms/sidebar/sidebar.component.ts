import {
  ChangeDetectionStrategy,
  Component,
  computed,
  input,
  output,
  signal,
} from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { MatTooltipModule } from '@angular/material/tooltip';
import { LucideAngularModule, LogOut, Menu, X } from 'lucide-angular';
import { AvatarComponent } from '../../atoms/avatar/avatar.component';
import { DividerComponent } from '../../atoms/divider/divider.component';
import type { NavItem } from '../../ui.types';

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [
    RouterLink,
    RouterLinkActive,
    MatTooltipModule,
    LucideAngularModule,
    AvatarComponent,
    DividerComponent,
  ],
  templateUrl: './sidebar.component.html',
  styleUrl: './sidebar.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class SidebarComponent {
  navItems = input<NavItem[]>([]);
  userPhotoUrl = input<string | undefined>(undefined);
  userInitials = input<string>('?');
  userName = input<string>('');
  userRole = input<string>('');
  collapsed = input<boolean>(false);

  itemSelected = output<NavItem>();
  logoutClick = output<void>();

  protected readonly MenuIcon = Menu;
  protected readonly CloseIcon = X;
  protected readonly LogOutIcon = LogOut;

  protected readonly isCollapsed = signal<boolean>(false);

  protected readonly showLabels = computed(
    () => !this.isCollapsed() && !this.collapsed(),
  );

  protected toggleCollapse(): void {
    this.isCollapsed.update((v) => !v);
  }

  protected onItemClick(item: NavItem): void {
    this.itemSelected.emit(item);
  }

  protected onLogout(): void {
    this.logoutClick.emit();
  }
}
