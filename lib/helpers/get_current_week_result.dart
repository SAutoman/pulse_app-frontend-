String getcurrentWeekResult(int currentPosition, int totalUsers) {
  if (currentPosition > totalUsers - 3) {
    return "DOWNGRADE";
  } else if (currentPosition <= 3) {
    return "UPGRADE";
  } else {
    return 'REMAIN';
  }
}
