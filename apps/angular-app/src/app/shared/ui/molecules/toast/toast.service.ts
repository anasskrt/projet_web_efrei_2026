import { inject, Injectable } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ToastComponent } from './toast.component';
import type { ToastData, ToastType } from '../../ui.types';

@Injectable({ providedIn: 'root' })
export class ToastService {
  private readonly snackBar = inject(MatSnackBar);

  private readonly DEFAULT_DURATION = 4000;

    show(data: ToastData): void {
    this.snackBar.openFromComponent(ToastComponent, {
      data,
      duration: data.duration ?? this.DEFAULT_DURATION,
      horizontalPosition: 'end',
      verticalPosition: 'bottom',
      panelClass: [`lah-toast--${data.type}`],
    });
  }

  success(message: string, duration?: number): void {
    this.show({ message, type: 'success', duration });
  }

  error(message: string, duration?: number): void {
    this.show({ message, type: 'error', duration });
  }

  warning(message: string, duration?: number): void {
    this.show({ message, type: 'warning', duration });
  }

  info(message: string, duration?: number): void {
    this.show({ message, type: 'info', duration });
  }
}
