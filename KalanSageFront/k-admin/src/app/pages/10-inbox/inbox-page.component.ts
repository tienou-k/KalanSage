import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { MaterialModule } from 'src/app/material.module';

interface Chat {
  avatar: string | null;
  name: string;
  message: string;
  time: string;
  unreadCount: number;
  messages: { text: string; time: string; sent: boolean }[];
}

@Component({
  selector: 'app-inbox',
  standalone: true,
  imports: [
    FormsModule, 
    MaterialModule,
  ],
  templateUrl: './inbox-page.component.html',
  styleUrls: ['./inbox-page.component.scss'],
})
export class InboxComponent {
  chatList: Chat[] = [
    {
      avatar: 'assets/images/avatar1.png',
      name: 'Awa Sow',
      message: '😀',
      time: '12:35',
      unreadCount: 1,
      messages: [
        { text: 'Hello! How can I help you?', time: '12:30', sent: false },
      ],
    },
    // Add more chat objects here
  ];

  selectedChatIndex: number | null = null;
  selectedChat: Chat | null = null;
  newMessage: string = '';

  selectChat(index: number): void {
    this.selectedChatIndex = index;
    this.selectedChat = this.chatList[index];
  }

  sendMessage(): void {
    if (this.newMessage.trim() && this.selectedChat) {
      this.selectedChat.messages.push({
        text: this.newMessage,
        time: 'Now',
        sent: true,
      });
      this.newMessage = '';
    }
  }
}
