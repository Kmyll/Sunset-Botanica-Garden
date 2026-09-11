import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class Sunset_botanical_gardenView extends WatchUi.WatchFace {
    private var _background as WatchUi.BitmapResource? = null;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
        _background =
            WatchUi.loadResource(Rez.Drawables.watchface_background) as
            WatchUi.BitmapResource;
    }

    function onShow() as Void {}

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        if (_background != null) {
            dc.drawBitmap(0, 0, _background);
        }

        drawTime(dc);
        drawDate(dc);
        drawSteps(dc);
        drawHeartRate(dc);
    }

  private function drawTime(dc as Dc) as Void {
    var clock = System.getClockTime();
    var settings = System.getDeviceSettings();
    var hour = clock.hour;
    var hourText;

    if (settings.is24Hour) {
        hourText = hour.format("%02d");
    } else {
        hour = hour % 12;

        if (hour == 0) {
            hour = 12;
        }

        hourText = hour.format("%d");
    }

    var timeText = Lang.format(
        "$1$:$2$",
        [
            hourText,
            clock.min.format("%02d")
        ]
    );

    dc.setColor(0xFFF4E5, Graphics.COLOR_TRANSPARENT);

    dc.drawText(
        dc.getWidth() / 2,
        112,
        Graphics.FONT_NUMBER_MILD,
        timeText,
        Graphics.TEXT_JUSTIFY_CENTER |
        Graphics.TEXT_JUSTIFY_VCENTER
    );
}
        var clock = System.getClockTime();

        var timeText = Lang.format("$1$:$2$", [
            clock.hour.format("%02d"),
            clock.min.format("%02d"),
        ]);

        dc.setColor(0xfff4e5, Graphics.COLOR_TRANSPARENT);

        dc.drawText(
            dc.getWidth() / 2,
            120,
            Graphics.FONT_NUMBER_MILD,
            timeText,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    private function drawDate(dc as Dc) as Void {
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

        var dateText = Lang.format("$1$ $2$ $3$", [
            today.day_of_week,
            today.day,
            today.month,
        ]);

        dc.setColor(0xc9d8ad, Graphics.COLOR_TRANSPARENT);

        dc.drawText(
            dc.getWidth() / 2,
            165,
            Graphics.FONT_XTINY,
            dateText,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    private function drawSteps(dc as Dc) as Void {
        var info = ActivityMonitor.getInfo();
        var stepsText = "--";

        if (info.steps != null) {
            stepsText = info.steps.format("%d");
        }

        dc.setColor(0xffa46d, Graphics.COLOR_TRANSPARENT);

        dc.drawText(
            292,
            322,
            Graphics.FONT_XTINY,
            stepsText,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    private function drawHeartRate(dc as Dc) as Void {
        var heartRateText = "--";
        var iterator = ActivityMonitor.getHeartRateHistory(1, true);
        var sample = iterator.next();

        if (
            sample != null &&
            sample.heartRate != null &&
            sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE
        ) {
            heartRateText = sample.heartRate.format("%d");
        }

        dc.setColor(0xc9d8ad, Graphics.COLOR_TRANSPARENT);

        dc.drawText(
            104,
            322,
            Graphics.FONT_XTINY,
            heartRateText,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    function onHide() as Void {}

    function onExitSleep() as Void {}

    function onEnterSleep() as Void {}
}
