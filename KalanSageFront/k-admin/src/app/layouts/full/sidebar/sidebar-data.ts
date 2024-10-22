import { NavItem } from './nav-item/nav-item';

export const navItems: NavItem[] = [
  {
    displayName: 'Dashboard',
    iconName: 'solar:home-line-duotone',
    route: '/dashboard',
  },
  {
    displayName: 'Abonnement',
    iconName: 'solar:card-line-duotone',
    route: '/abonnement',
  },
  {
    displayName: 'Modules',
    iconName: 'solar:layers-line-duotone',
    route: '/module',
  },
  {
    displayName: 'Users',
    iconName: 'solar:users-group-rounded-line-duotone',
    route: '/user',
  },
  {
    displayName: 'Forum',
    iconName: 'solar:chat-dots-line-duotone',
    route: '/forum',
  },
  {
    displayName: 'Partenaire',
    iconName: 'solar:book-bookmark-line-duotone',
    route: '/partenaire',
  },
  {
    displayName: 'Live',
    iconName: 'solar:play-stream-line-duotone',
    route: '/live',
  },
  {
    navCap: 'Insight',
  },
  {
    displayName: 'Notification',
    iconName: 'solar:bell-line-duotone',
    route: '/notification',
  },
  {
    displayName: 'Inbox',
    iconName: 'solar:inbox-line-duotone',
    route: '/inbox',
  },
];
