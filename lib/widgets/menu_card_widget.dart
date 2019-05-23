import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sale_form_demo/services/menu_slide_provider.dart';
import 'package:sale_form_demo/utils/size_config.dart';
import 'package:sale_form_demo/utils/slide_up_route.dart';

class MenuCardWidget extends StatelessWidget {
  final int positionMultiplier;
  final Widget navigateTo;
  final Color color;
  final String title;
  final double height;
  final double width;
  final String heroTag;


  MenuCardWidget(
      {@required this.height,
        @required this.width,
        @required this.color,
        @required this.title,
        @required this.heroTag,
        @required this.positionMultiplier,
        @required this.navigateTo})
      : assert(color != null),
        assert(height != null),
        assert(width != null),
        assert(title != null),
        assert(heroTag != null),
        assert(positionMultiplier != null),
        assert(navigateTo != null);

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuSlideProvider>(context);

    final double cardContainerHeight = height - 60;
    final double cardHeight = cardContainerHeight / 4;
    final double cardPosition = cardHeight - 20;

    double beginOffsetPosition = 0;
    double endOffsetPosition = 0;
    if (menuProvider.getSlideStatus()){ //if true, set offset postion to start animation
      beginOffsetPosition = 0;
      endOffsetPosition = -1 * positionMultiplier.toDouble();
    } else{ // if not, reverse animation
      beginOffsetPosition = -1 * positionMultiplier.toDouble();
      endOffsetPosition = 0;
      if (menuProvider.getActiveMenu() == positionMultiplier){// don't move the active menu because of hero animation
        beginOffsetPosition = 0;
        endOffsetPosition = 0;
      }
    }

    // A method that launches the SelectionScreen and awaits the result from
    // Navigator.pop!
    _navigateAndAnimate(BuildContext context) async {
      // Navigator.push returns a Future that will complete after we call
      // Navigator.pop on the Selection Screen!
      menuProvider.setSlideStatus(true);
      menuProvider.setActiveMenu(positionMultiplier);

      final result = await Navigator.push(
        context,
        SlideUpRoute(page:navigateTo),
      );

      // After the Selection Screen returns a result, animate back
      if(result){
        menuProvider.setSlideStatus(false);
      }

    }


    return Positioned(
      top: cardPosition * positionMultiplier,
      child: GestureDetector(
        onTap: () {
          _navigateAndAnimate(context);
        },
        child: Hero(
          tag: heroTag,
          child: Animator( // slide up animation
            tween: Tween<Offset>(begin: Offset(0, beginOffsetPosition), end: Offset(0, endOffsetPosition)),
            duration: Duration(milliseconds: 200),
            builder: (anim) => FractionalTranslation(
              translation: anim.value,
              child: Container(
                width: width,
                height: cardHeight,
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  color: color,
                  borderRadius: new BorderRadius.only(
                      bottomLeft: const Radius.circular(15.0), bottomRight: const Radius.circular(15.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: new Offset(0.0, 4.0),
                      blurRadius: 10.0,
                    )
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}