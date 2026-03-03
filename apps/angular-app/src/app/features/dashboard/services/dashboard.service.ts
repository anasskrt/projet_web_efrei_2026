import { inject, Injectable } from '@angular/core';
import { toObservable } from '@angular/core/rxjs-interop';
import { catchError, combineLatest, forkJoin, from, map, of, startWith, switchMap } from 'rxjs';
import type { Observable } from 'rxjs';
import { AuthService } from '../../../core/services/auth.service';
import { UserService } from '../../../core/services/user.service';
import { ConversationService } from '../../chat/services/conversation.service';
import type { Conversation } from '../../chat/models/conversation.model';
import type { DashboardUnreadMessage, StudentInfo } from '../models/dashboard.models';

@Injectable({ providedIn: 'root' })
export class DashboardService {
  private readonly authService = inject(AuthService);
  private readonly userService = inject(UserService);
  private readonly conversationService = inject(ConversationService);

  private readonly authState$ = combineLatest({
    user: toObservable(this.authService.currentUser),
    isLoading: toObservable(this.authService.isLoading),
  });

  readonly students$: Observable<StudentInfo[] | null> = this.authState$.pipe(
    switchMap(({ user, isLoading }) => {
      if (isLoading) return of(null);
      if (!user || user.role !== 'volunteer') return of([]);
      return from(this.userService.getStudentsForVolunteer(user.uid)).pipe(
        map((users) =>
          users.map((u) => ({
            id: u.uid,
            firstName: u.firstName,
            lastName: u.lastName,
            // TODO: brancher TaskService
            taskCount: null,
          })),
        ),
        startWith(null),
        catchError(() => of([])),
      );
    }),
  );

  readonly unreadMessages$: Observable<DashboardUnreadMessage[] | null> = this.authState$.pipe(
    switchMap(({ user, isLoading }) => {
      if (isLoading) return of(null);
      if (!user) return of([]);
      return this.conversationService.watchUnreadConversations(user.uid).pipe(
        switchMap((conversations) => {
          if (conversations.length === 0) return of<DashboardUnreadMessage[]>([]);
          return forkJoin(
            conversations.map((c) => this._resolveMessagePreview(c, user.uid)),
          );
        }),
        startWith(null),
        catchError(() => of([])),
      );
    }),
  );

  readonly totalUnreadCount$: Observable<number> = this.authState$.pipe(
    switchMap(({ user, isLoading }) => {
      if (isLoading || !user) return of(0);
      return this.conversationService.watchTotalUnreadCount(user.uid);
    }),
    catchError(() => of(0)),
  );

  private _resolveMessagePreview(
    conversation: Conversation,
    currentUserId: string,
  ): Observable<DashboardUnreadMessage> {
    if (conversation.type === 'group') {
      return of({
        conversationId: conversation.id,
        senderName: conversation.name ?? 'Groupe',
        excerpt: conversation.lastMessage ?? '',
        unreadCount: conversation.unreadCount,
        updatedAt: conversation.updatedAt,
      });
    }
    const otherUid =
      conversation.members.find((m) => m !== currentUserId) ?? currentUserId;
    return from(this.userService.getUser(otherUid)).pipe(
      map((u) => ({
        conversationId: conversation.id,
        senderName: u ? `${u.firstName} ${u.lastName}` : 'Utilisateur',
        excerpt: conversation.lastMessage ?? '',
        unreadCount: conversation.unreadCount,
        updatedAt: conversation.updatedAt,
      })),
      catchError(() =>
        of({
          conversationId: conversation.id,
          senderName: 'Utilisateur',
          excerpt: conversation.lastMessage ?? '',
          unreadCount: conversation.unreadCount,
          updatedAt: conversation.updatedAt,
        }),
      ),
    );
  }
}
