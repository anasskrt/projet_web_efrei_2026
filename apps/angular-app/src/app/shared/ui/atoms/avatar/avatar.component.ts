import { ChangeDetectionStrategy, Component, computed, input } from '@angular/core';
import type { AvatarSize } from '../../ui.types';

@Component({
  selector: 'app-avatar',
  standalone: true,
  templateUrl: './avatar.component.html',
  styleUrl: './avatar.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class AvatarComponent {
  photoUrl = input<string | null | undefined>(undefined);
    initials = input<string>('?');
  size = input<AvatarSize>(40);
  alt = input<string>('Avatar utilisateur');

  protected hasPhoto = computed(() => !!this.photoUrl());

  protected sizeStyle = computed(() => ({
    width: `${this.size()}px`,
    height: `${this.size()}px`,
    'font-size': `${Math.round(this.size() * 0.36)}px`,
  }));

  protected onImageError(event: Event): void {
    const img = event.target as HTMLImageElement;
    img.style.display = 'none';
  }
}
