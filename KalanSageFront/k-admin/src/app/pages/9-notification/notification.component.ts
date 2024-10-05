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
    {
      senderImg: 'assets/images/user1.jpg',
      title: 'Nouvelle mise à jour',
      message: 'La version 1.2.3 est maintenant disponible!',
      time: 'Il y a 10 minutes',
    },
    {
      senderImg: 'assets/images/user2.jpg',
      title: 'Message important',
      message: "N'oubliez pas de vérifier votre courrier.",
      time: 'Il y a 2 heures',
    },
    {
      senderImg: 'assets/images/user3.jpg',
      title: 'Invitation',
      message: 'Vous avez été invité à rejoindre le groupe Angular Devs.',
      time: 'Hier',
    },
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
