import { Component } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { MaterialModule } from 'src/app/material.module';

interface Session {
  title: string;
  host: string;
  participants: number;
}

@Component({
  selector: 'app-live',
  standalone: true,
  imports: [MaterialModule],
  templateUrl: './live.component.html',
  styleUrls: ['./live.component.scss'],
})
export class LiveComponent {
  displayedColumns: string[] = ['title', 'host', 'participants', 'actions'];
  dataSource = new MatTableDataSource<Session>([
  ]);

  // Methods for actions
  viewDetails(session: Session): void {
    console.log('Viewing details for:', session);
  }

  startLive(): void {
    console.log('Starting live session:',);
  }

  saveSession(session: Session): void {
    console.log('Saving session:', session);
  }

  deleteSession(session: Session): void {
    console.log('Deleting session:', session);
  }
}
