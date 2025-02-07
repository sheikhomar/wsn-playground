 #include <Timer.h>
 #include "BlinkToRadioC.h"
 
module BlinkToRadioC {
   uses interface Boot;
   uses interface Leds;
   uses interface Timer<TMilli> as Timer0;
   uses interface Packet;
   uses interface AMPacket;
   uses interface AMSend;
   uses interface Receive;
   uses interface SplitControl as AMControl;
}
implementation {
  uint16_t counter = 0;
  bool busy = FALSE;
  message_t pkt;
 
  event void Boot.booted() {
    call AMControl.start();
  }
  
  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Leds.led1On();
      //call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }
 
  event void Timer0.fired() {
    //counter++;
    //counter = 5;
    //call Leds.set(counter);
    if (!busy) {
      BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*)(call Packet.getPayload(&pkt, sizeof (BlinkToRadioMsg)));
      btrpkt->nodeid = TOS_NODE_ID;
      btrpkt->counter = counter;
      if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BlinkToRadioMsg)) == SUCCESS) {
        busy = TRUE;
      }
    }
  }

  event void AMSend.sendDone(message_t *msg, error_t error){
    if (&pkt == msg) {
      busy = FALSE;
    }
  }
  
  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
    //call Leds.led0On();
    //call Leds.led1On();
    //call Leds.led2On();
    if (len == sizeof(BlinkToRadioMsg)) {
     BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*)payload;
      if (btrpkt->nodeid == 43) {
      	call Leds.set(btrpkt->counter);
      }
    }
    return msg;
  }
}