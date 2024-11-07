import { Component } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { MaterialModule } from 'src/app/material.module';

interface Notification {
  senderImg: string;
  title: string;
  message: string;
  time: string;
}

@Component({
  selector: 'app-notifications',
  standalone: true,
  imports: [MaterialModule],
  templateUrl: './notification.component.html',
  styleUrls: ['./notification.component.scss'],
})
export class NotificationComponent {
  notifications: Notification[] = [
  ];

  selectedNotificationIndex: number | null = null;
  selectedNotification: Notification | null = null;

  selectNotification(index: number): void {
    this.selectedNotificationIndex = index;
    this.selectedNotification = this.notifications[index];
  }

  viewDetails(index: number): void {
    this.selectNotification(index);
  }

  deleteNotification(index: number): void {
    this.notifications.splice(index, 1);
    this.selectedNotification = null;
    this.selectedNotificationIndex = null;
  }

  onUploadClick(): void {
    // Handle upload logic here
  }
}
