//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

part of table_calendar;

/// Callback exposing currently selected day.
typedef void OnDaySelected(DateTime day, List events, bool isTapAction);

/// Callback exposing currently visible days (first and last of them), as well as current `CalendarFormat`.
typedef void OnVisibleDaysChanged(
    DateTime first, DateTime last, CalendarFormat format);

/// Signature for reacting to header gestures. Exposes current month and year as a `DateTime` object.
typedef void HeaderGestureCallback(DateTime focusedDay);

/// Builder signature for any text that can be localized and formatted with `DateFormat`.
typedef String TextBuilder(DateTime date, dynamic locale);

/// Signature for enabling days.
typedef bool EnabledDayPredicate(DateTime day);

/// Format to display the `TableCalendar` with.
enum CalendarFormat { month, twoWeeks, week }

/// Available animations to update the `CalendarFormat` with.
enum FormatAnimation { slide, scale }

/// Available day of week formats. `TableCalendar` will start the week with chosen day.
/// * `StartingDayOfWeek.monday`: Monday - Sunday
/// * `StartingDayOfWeek.tuesday`: Tuesday - Monday
/// * `StartingDayOfWeek.wednesday`: Wednesday - Tuesday
/// * `StartingDayOfWeek.thursday`: Thursday - Wednesday
/// * `StartingDayOfWeek.friday`: Friday - Thursday
/// * `StartingDayOfWeek.saturday`: Saturday - Friday
/// * `StartingDayOfWeek.sunday`: Sunday - Saturday
enum StartingDayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
}

int _getWeekdayNumber(StartingDayOfWeek weekday) {
  return StartingDayOfWeek.values.indexOf(weekday) + 1;
}

/// Gestures available to interal `TableCalendar`'s logic.
enum AvailableGestures { none, verticalSwipe, horizontalSwipe, all }

/// Highly customizable, feature-packed Flutter Calendar with gestures, animations and multiple formats.
class TableCalendar extends StatefulWidget {
  /// Controller required for `TableCalendar`.
  /// Use it to update `events`, `holidays`, etc.
  final CalendarController calendarController;

  /// Locale to format `TableCalendar` dates with, for example: `'en_US'`.
  ///
  /// If nothing is provided, a default locale will be used.
  final dynamic locale;

  /// `Map` of events.
  /// Each `DateTime` inside this `Map` should get its own `List` of objects (i.e. events).
  final Map<DateTime, List> events;

  /// `Map` of holidays.
  /// This property allows you to provide custom holiday rules.
  final Map<DateTime, List> holidays;

  /// Called whenever any day gets tapped.
  final OnDaySelected onDaySelected;

  /// Called whenever any day gets long pressed.
  final OnDaySelected onDayLongPressed;

  /// Called whenever any unavailable day gets tapped.
  /// Replaces `onDaySelected` for those days.
  final VoidCallback onUnavailableDaySelected;

  /// Called whenever any unavailable day gets long pressed.
  /// Replaces `onDaySelected` for those days.
  final VoidCallback onUnavailableDayLongPressed;

  /// Called whenever header gets tapped.
  final HeaderGestureCallback onHeaderTapped;

  /// Called whenever header gets long pressed.
  final HeaderGestureCallback onHeaderLongPressed;

  /// Called whenever the range of visible days changes.
  final OnVisibleDaysChanged onVisibleDaysChanged;

  /// Currently selected day.
  final DateTime selectedDay;

  /// Currently focused day. Determines currently visible year and month/week;
  final DateTime focusedDay;

  /// The first day of `TableCalendar`.
  /// Days before it will use `unavailableStyle` and run `onUnavailableDaySelected` callback.
  final DateTime startDay;

  /// The last day of `TableCalendar`.
  /// Days after it will use `unavailableStyle` and run `onUnavailableDaySelected` callback.
  final DateTime endDay;

  /// List of days treated as weekend days.
  /// Use built-in `DateTime` weekday constants (e.g. `DateTime.monday`) instead of `int` literals (e.q. `1`).
  final List<int> weekendDays;

  /// Currently displayed `CalendarFormat`.
  final CalendarFormat calendarFormat;

  /// `Map` of `CalendarFormat`s and `String` names associated with them.
  /// Those `CalendarFormat`s will be used by internal logic to manage displayed format.
  ///
  /// To ensure proper vertical Swipe behavior, `CalendarFormat`s should be in descending order (eg. from biggest to smallest).
  ///
  /// For example:
  /// ```dart
  /// availableCalendarFormats: const {
  ///   CalendarFormat.month: 'Month',
  ///   CalendarFormat.week: 'Week',
  /// }
  /// ```
  final Map<CalendarFormat, String> availableCalendarFormats;

  /// Used to show/hide Header.
  final bool headerVisible;

  /// Function deciding whether given day should be enabled or not.
  /// If `false` is returned, this day will be unavailable.
  final EnabledDayPredicate enabledDayPredicate;

  /// Used for setting the height of `TableCalendar`'s rows.
  final double rowHeight;

  /// Animation to run when `CalendarFormat` gets changed.
  final FormatAnimation formatAnimation;

  /// `TableCalendar` will start weeks with provided day.
  /// Use `StartingDayOfWeek.monday` for Monday - Sunday week format.
  /// Use `StartingDayOfWeek.sunday` for Sunday - Saturday week format.
  final StartingDayOfWeek startingDayOfWeek;

  /// `HitTestBehavior` for every day cell inside `TableCalendar`.
  final HitTestBehavior dayHitTestBehavior;

  /// Specify Gestures available to `TableCalendar`.
  /// If `AvailableGestures.none` is used, the Calendar will only be interactive via buttons.
  final AvailableGestures availableGestures;

  /// Configuration for vertical Swipe detector.
  final SimpleSwipeConfig simpleSwipeConfig;

  /// Style for `TableCalendar`'s content.
  final CalendarStyle calendarStyle;

  /// Style for DaysOfWeek displayed between `TableCalendar`'s Header and content.
  final DaysOfWeekStyle daysOfWeekStyle;

  /// Style for `TableCalendar`'s Header.
  final HeaderStyle headerStyle;

  /// Set of Builders for `TableCalendar` to work with.
  final CalendarBuilders builders;

  TableCalendar({
    Key key,
    @required this.calendarController,
    this.locale,
    this.events = const {},
    this.holidays = const {},
    this.onDaySelected,
    this.onDayLongPressed,
    this.onUnavailableDaySelected,
    this.onUnavailableDayLongPressed,
    this.onHeaderTapped,
    this.onHeaderLongPressed,
    this.onVisibleDaysChanged,
    this.selectedDay,
    this.startDay,
    this.endDay,
    this.weekendDays = const [DateTime.saturday, DateTime.sunday],
    this.calendarFormat = CalendarFormat.month,
    this.availableCalendarFormats = const {
      CalendarFormat.month: 'Month',
      CalendarFormat.twoWeeks: '2 weeks',
      CalendarFormat.week: 'Week',
    },
    this.headerVisible = true,
    this.enabledDayPredicate,
    this.rowHeight = 60.0,
    this.formatAnimation = FormatAnimation.slide,
    this.startingDayOfWeek = StartingDayOfWeek.sunday,
    this.dayHitTestBehavior = HitTestBehavior.deferToChild,
    this.availableGestures = AvailableGestures.all,
    this.simpleSwipeConfig = const SimpleSwipeConfig(
      verticalThreshold: 25.0,
      swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
    ),
    this.calendarStyle = const CalendarStyle(),
    this.daysOfWeekStyle = const DaysOfWeekStyle(),
    this.headerStyle = const HeaderStyle(),
    this.builders = const CalendarBuilders(),
    this.focusedDay,
  })  : assert(calendarController != null),
        assert(availableCalendarFormats.keys.contains(calendarFormat)),
        assert(availableCalendarFormats.length <= CalendarFormat.values.length),
        assert(rowHeight != null),
        assert(rowHeight > 0.0),
        assert(weekendDays != null),
        assert(weekendDays.isNotEmpty
            ? weekendDays.every(
                (day) => day >= DateTime.monday && day <= DateTime.sunday)
            : true),
        super(key: key);

  @override
  _TableCalendarState createState() => _TableCalendarState();
}

class _TableCalendarState extends State<TableCalendar> {
  @override
  void initState() {
    super.initState();

    widget.calendarController._init(
      events: widget.events,
      holidays: widget.holidays,
      initialDay: widget.selectedDay,
      initialFormat: widget.calendarFormat,
      availableCalendarFormats: widget.availableCalendarFormats,
      useNextCalendarFormat: widget.headerStyle.formatButtonShowsNext,
      startingDayOfWeek: widget.startingDayOfWeek,
      onVisibleDaysChanged: widget.onVisibleDaysChanged,
      includeInvisibleDays: widget.calendarStyle.outsideDaysVisible,
      rowHeight: widget.rowHeight,
    );
  }

  @override
  void didUpdateWidget(TableCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.events != widget.events) {
      widget.calendarController._events = widget.events;
    }

    if (oldWidget.holidays != widget.holidays) {
      widget.calendarController._holidays = widget.holidays;
    }

    if (oldWidget.calendarFormat != widget.calendarFormat) {
      if (widget.calendarController._calendarFormat.value !=
          widget.calendarFormat) {
        widget.calendarController._setCalendarFormat(
          widget.calendarFormat,
          triggerCallback: false,
        );
      }
    }

    if (widget.selectedDay != null) {
      if (!widget.calendarController
          .isSameDay(oldWidget.selectedDay, widget.selectedDay)) {
        if (!widget.calendarController.isSameDay(
            widget.calendarController._selectedDay, widget.selectedDay)) {
          final normalizedDate =
              widget.calendarController._normalizeDate(widget.selectedDay);
          widget.calendarController._focusedDay.value = normalizedDate;
          widget.calendarController._selectedDay = normalizedDate;
          widget.calendarController._visibleDays =
              widget.calendarController._getVisibleDays(normalizedDate);

          _selectedDayCallback(normalizedDate);
        }
      }
    }

    if (widget.focusedDay != null) {
      if (!widget.calendarController
          .isSameDay(oldWidget.focusedDay, widget.focusedDay)) {
        if (!widget.calendarController.isSameDay(
            widget.calendarController._focusedDay.value, widget.focusedDay)) {
          widget.calendarController._focusedDay.value =
              widget.calendarController._normalizeDate(widget.focusedDay);
        }
      }
    }
  }

  void _selectedDayCallback(DateTime day) {
    if (widget.onDaySelected != null) {
      widget.onDaySelected(day, widget.events[_getEventKey(day)] ?? [], false);
    }
  }

  DateTime _getEventKey(DateTime day) {
    return widget.events.keys.firstWhere(
        (it) => widget.calendarController.isSameDay(it, day),
        orElse: () => null);
  }

  void _toggleCalendarFormat() {
    setState(() {
      widget.calendarController.toggleCalendarFormat();
    });
  }

  void _onHeaderTapped() {
    if (widget.onHeaderTapped != null) {
      widget.onHeaderTapped(widget.calendarController.focusedDay);
    }
  }

  void _onHeaderLongPressed() {
    if (widget.onHeaderLongPressed != null) {
      widget.onHeaderLongPressed(widget.calendarController.focusedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.headerVisible) _buildHeader(),
        Padding(
          padding: widget.calendarStyle.contentPadding,
          child: ValueListenableBuilder<double>(
            valueListenable: widget.calendarController._calendarHeight,
            builder: (context, value, child) {
              return AnimatedContainer(
                height: value,
                duration: const Duration(milliseconds: 200),
                child: child,
              );
            },
            child: PageView.custom(
              controller: widget.calendarController._pageController,
              physics: widget.availableGestures == AvailableGestures.none ||
                      widget.availableGestures ==
                          AvailableGestures.verticalSwipe
                  ? NeverScrollableScrollPhysics()
                  : PageScrollPhysics(),
              childrenDelegate: SliverChildBuilderDelegate(
                (context, i) {
                  final focusedDay =
                      widget.calendarController._getFocusedDay(pageIndex: i);

                  final child = _CalendarPage(
                    focusedDay: focusedDay,
                    locale: widget.locale,
                    rowHeight: widget.rowHeight,
                    calendarController: widget.calendarController,
                    calendarStyle: widget.calendarStyle,
                    builders: widget.builders,
                    daysOfWeekStyle: widget.daysOfWeekStyle,
                    dayHitTestBehavior: widget.dayHitTestBehavior,
                    events: widget.events,
                    holidays: widget.holidays,
                    startDay: widget.startDay,
                    endDay: widget.endDay,
                    weekendDays: widget.weekendDays,
                    onDaySelected: widget.onDaySelected,
                    onDayLongPressed: widget.onDayLongPressed,
                    onUnavailableDaySelected: widget.onUnavailableDaySelected,
                    onUnavailableDayLongPressed:
                        widget.onUnavailableDayLongPressed,
                    enabledDayPredicate: widget.enabledDayPredicate,
                  );

                  if (widget.availableGestures == AvailableGestures.all ||
                      widget.availableGestures ==
                          AvailableGestures.verticalSwipe) {
                    return SimpleGestureDetector(
                      swipeConfig: widget.simpleSwipeConfig,
                      onVerticalSwipe: (direction) {
                        widget.calendarController.swipeCalendarFormat(
                            isSwipeUp: direction == SwipeDirection.up);
                        widget.calendarController
                            ._updateVisibleDays(pageIndex: i);
                        setState(() {});
                      },
                      child: child,
                    );
                  } else {
                    return child;
                  }
                },
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
              ),
              onPageChanged: (i) {
                widget.calendarController._updateVisibleDays(pageIndex: i);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final children = <Widget>[
      _CustomIconButton(
        icon: widget.headerStyle.leftChevronIcon,
        onTap: widget.calendarController._selectPrevious,
        margin: widget.headerStyle.leftChevronMargin,
        padding: widget.headerStyle.leftChevronPadding,
      ),
      Expanded(
        child: GestureDetector(
          onTap: _onHeaderTapped,
          onLongPress: _onHeaderLongPressed,
          child: ValueListenableBuilder<DateTime>(
            valueListenable: widget.calendarController._focusedDay,
            builder: (context, value, _) {
              return Text(
                widget.headerStyle.titleTextBuilder != null
                    ? widget.headerStyle.titleTextBuilder(value, widget.locale)
                    : DateFormat.yMMMM(widget.locale).format(value),
                style: widget.headerStyle.titleTextStyle,
                textAlign: widget.headerStyle.centerHeaderTitle
                    ? TextAlign.center
                    : TextAlign.start,
              );
            },
          ),
        ),
      ),
      _CustomIconButton(
        icon: widget.headerStyle.rightChevronIcon,
        onTap: widget.calendarController._selectNext,
        margin: widget.headerStyle.rightChevronMargin,
        padding: widget.headerStyle.rightChevronPadding,
      ),
    ];

    if (widget.headerStyle.formatButtonVisible &&
        widget.availableCalendarFormats.length > 1) {
      children.insert(2, const SizedBox(width: 8.0));
      children.insert(3, _buildFormatButton());
    }

    return Container(
      decoration: widget.headerStyle.decoration,
      margin: widget.headerStyle.headerMargin,
      padding: widget.headerStyle.headerPadding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: children,
      ),
    );
  }

  Widget _buildFormatButton() {
    return GestureDetector(
      onTap: _toggleCalendarFormat,
      child: Container(
        decoration: widget.headerStyle.formatButtonDecoration,
        padding: widget.headerStyle.formatButtonPadding,
        child: Text(
          widget.calendarController._getFormatButtonText(),
          style: widget.headerStyle.formatButtonTextStyle,
        ),
      ),
    );
  }
}
