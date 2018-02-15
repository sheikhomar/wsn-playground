#ifndef BLINK_TO_RADIO_C_H
#define BLINK_TO_RADIO_C_H


enum {
  AM_BLINKTORADIO = 6,
  TIMER_PERIOD_MILLI = 1000
};

typedef nx_struct BlinkToRadioMsg {
  nx_uint16_t nodeid;
  nx_uint16_t counter;
} BlinkToRadioMsg;

#endif /* BLINK_TO_RADIO_C_H */
