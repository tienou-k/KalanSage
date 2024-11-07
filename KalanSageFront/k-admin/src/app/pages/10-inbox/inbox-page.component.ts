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
  chatList: Chat[] = [];

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
