import 'package:flutter/material.dart';
import 'package:pulse_mate_app/models/club_model.dart';
import 'package:pulse_mate_app/ui/screens/club_details_screen.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';

class ClubLogoThumbnail extends StatelessWidget {
  const ClubLogoThumbnail({
    super.key,
    required this.club,
    this.navigationActive = true,
  });

  final Club club;
  final bool navigationActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigationActive
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClubDetailsScreen(club: club),
                ),
              )
          : null,
      child: Tooltip(
        message: club.name,
        child: Container(
          margin: const EdgeInsets.only(right: 8.0),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            // Slightly larger to contain the image border
            borderRadius: BorderRadius.circular(10.3),
            border: Border.all(color: kSecondaryColor, width: 0.3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0), // Adjust radius here
            child: Image.network(
              club.imageUrl,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200], // Fallback color on image load failure
                child: const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
