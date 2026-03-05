import { inject, Injectable, type Type } from '@angular/core';
import { MatDialog, type MatDialogRef } from '@angular/material/dialog';
import type { ModalConfig, ModalSize } from '../../ui.types';

const MODAL_WIDTHS: Record<ModalSize, string> = {
  sm: '480px',
  md: '640px',
  lg: '800px',
};

@Injectable({ providedIn: 'root' })
export class ModalService {
  private readonly dialog = inject(MatDialog);

    open<T, R = unknown>(
    component: Type<T>,
    config: ModalConfig<R> = { title: '' },
  ): MatDialogRef<T> {
    const size = config.size ?? 'md';

    return this.dialog.open(component, {
      width: MODAL_WIDTHS[size],
      maxWidth: '90vw',
      maxHeight: '90vh',
      panelClass: 'lah-dialog-panel',
      backdropClass: 'lah-dialog-backdrop',
      data: config.data,
      ariaLabel: config.title,
      autoFocus: 'first-tabbable',
      restoreFocus: true,
    });
  }

  closeAll(): void {
    this.dialog.closeAll();
  }
}
