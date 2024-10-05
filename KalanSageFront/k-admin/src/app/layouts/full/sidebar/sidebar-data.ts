import { NavItem } from './nav-item/nav-item';

export const navItems: NavItem[] = [
  {
    displayName: 'Dashboard',
    iconName: 'solar:widget-add-line-duotone',
    route: '/dashboard',
  },
  {
    displayName: 'Abonnement',
    iconName: 'solar:archive-minimalistic-line-duotone',
    route: '/abonnement',
  },
  {
    displayName: 'Modules',
    iconName: 'solar:danger-circle-line-duotone',
    route: '/module',
  },
  {
    displayName: 'Users',
    iconName: 'solar:bookmark-square-minimalistic-line-duotone',
    route: '/user',
  },
  {
    displayName: 'Forum',
    iconName: 'solar:file-text-line-duotone',
    route: '/forum',
  },
  {
    displayName: 'Partenaire',
    iconName: 'solar:text-field-focus-line-duotone',
    route: '/partenaire',
  },
  {
    displayName: 'Live',
    iconName: 'solar:file-text-line-duotone',
    route: '/live',
  },
  // {
  //   displayName: 'Parametre',
  //   iconName: 'solar:tablet-line-duotone',
  //   route: '/parametre',
  // },
  {
    navCap: 'Insight',
  },
  {
    displayName: 'Notification',
    iconName: 'solar:sticker-smile-circle-2-line-duotone',
    route: '/notification',
  },
  {
    displayName: 'Inbox',
    iconName: 'solar:planet-3-line-duotone',
    route: '/inbox',
  },
];
