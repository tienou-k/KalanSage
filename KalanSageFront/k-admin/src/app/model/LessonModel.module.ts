import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

// lesson.model.ts
export interface LessonModel {
duration: any;
    idLecon: number;
    titre: string;
    description: string;
    contenu: any; 
    dateAjout: string;
    dateModification?: string;
    videoPath?: string; 
    quiz?: any; 
    completed?: boolean; 
    locked?: boolean; 
}

