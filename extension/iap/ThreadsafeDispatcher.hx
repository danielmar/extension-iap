package extension.iap;
import openfl.events.EventDispatcher;
import openfl.events.Event;
#if cpp
import cpp.vm.Deque;
#end

class ThreadsafeDispatcher extends EventDispatcher {
    
    private var _eventQueue:Deque<Event>;
    private var _active:Bool = false;
    public function new():Void {
        super();
        _eventQueue = new Deque<Event>();
        
    }

    private function handleTick(e:Event):Void {
        var event:Event = _eventQueue.pop(false);
		while (event != null) {
			super.dispatchEvent(event);
			event = _eventQueue.pop(false);
		}
    }

    override public function dispatchEvent(event:Event):Bool {
        _eventQueue.add(event);
        return true;
    }

    public function activate():Void {
        if (!_active) {
            _active = true;
            openfl.Lib.current.stage.addEventListener(Event.ENTER_FRAME, handleTick);
        }
    }
}