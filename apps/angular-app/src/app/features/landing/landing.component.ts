import { ChangeDetectionStrategy, Component } from '@angular/core';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-landing',
  standalone: true,
  imports: [RouterLink],
  templateUrl: './landing.component.html',
  styleUrl: './landing.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class LandingComponent {
  readonly reviews = [
    {
      name: 'Amira B.',
      role: 'Élève en 3ème',
      avatar: 'AB',
      text: "Grâce à mon tuteur, j'ai réussi mon brevet avec mention ! Les séances sont claires et bien adaptées à mon niveau.",
      rating: 5,
    },
    {
      name: 'Lucas M.',
      role: 'Lycéen, Terminale',
      avatar: 'LM',
      text: "J'avais du mal en mathématiques, mais les bénévoles sont très patients. Je me sens bien plus confiant maintenant.",
      rating: 5,
    },
    {
      name: 'Sofia K.',
      role: 'Étudiante en L1',
      avatar: 'SK',
      text: "Une plateforme vraiment top. Mon tuteur en économie m'a aidée à comprendre des notions complexes en quelques séances.",
      rating: 4,
    },
    {
      name: 'Théo D.',
      role: 'Élève en CM2',
      avatar: 'TD',
      text: 'Ma maman a créé mon compte et depuis je progresse beaucoup en français. Mon tuteur est super sympa !',
      rating: 5,
    },
  ];

  readonly subjects = [
    { icon: '💻', label: 'Informatique' },
    { icon: '📐', label: 'Mathématiques' },
    { icon: '🔬', label: 'Sciences' },
    { icon: '📚', label: 'Lettres' },
    { icon: '🌍', label: 'Histoire-Géo' },
    { icon: '🗣️', label: 'Langues' },
    { icon: '⚗️', label: 'Chimie' },
    { icon: '📊', label: 'Économie' },
  ];
}
