import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { MaterialModule } from 'src/app/material.module';

@Component({
  selector: 'app-video-player',
  standalone: true,
  imports: [MaterialModule],
  templateUrl: './video-player.component.html',
  styleUrls: ['./video-player.component.scss'],
})
export class VideoPlayerComponent {
  isFullScreen: boolean = false;

  constructor(
    @Inject(MAT_DIALOG_DATA)
    public data: { videoPath: string },
    private dialogRef: MatDialogRef<VideoPlayerComponent>
  ) {}

  onClose(): void {
    this.dialogRef.close();
  }

  togglePlay(video: HTMLVideoElement): void {
    if (video.paused) {
      video.play();
    } else {
      video.pause();
    }
  }

  toggleFullScreen(video: HTMLVideoElement): void {
    if (!this.isFullScreen) {
      if (video.requestFullscreen) {
        video.requestFullscreen();
      } else if (video.requestFullscreen) {
        video.requestFullscreen(); // Safari
      } else if (video.requestFullscreen) {
        video.requestFullscreen(); // IE11
      }
    } else {
      if (document.exitFullscreen) {
        document.exitFullscreen();
      } else if (document.exitFullscreen) {
        document.exitFullscreen(); // Safari
      } else if (document.exitFullscreen) {
        document.exitFullscreen(); // IE11
      }
    }
    this.isFullScreen = !this.isFullScreen;
  }

  changeVolume(video: HTMLVideoElement, event: Event): void {
    const volume = (event.target as HTMLInputElement).valueAsNumber;
    video.volume = volume;
  }

  setInitialVolume(video: HTMLVideoElement): void {
    video.volume = 0.5; // Set initial volume to 50%
  }
}
