package com.cta;

import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup.LayoutParams;

public class FrequencyClickTime extends Activity {

	// 用來處理沒touch時將畫面清空
	Handler myHandler = new Handler() {
		public void handleMessage(Message msg) {
			if (msg.what == 0x101) {
				if (flagTouching) {
					flagTouching = false;
				} else {
					((Circle) circle).showRGB = 0;
					circle.invalidate();
				}
				Message m = new Message();
				m.what = 0x101;
				this.sendMessageDelayed(m, 500);
			}
		}
	};
	/** Called when the activity is first created. */
	long time;
	static Pointer pointer[];
	static Pointer clicked[];
	static ClickedPoint cp;
	View circle;
	int pointers;
	boolean flagTouching = false;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		cp = new ClickedPoint();
		pointer = new Pointer[10];
		clicked = new Pointer[10];
		for (int i = 0; i < 10; i++) {
			pointer[i] = new Pointer();
		}

		circle = new Circle(this);

		LayoutParams params = new LayoutParams(LayoutParams.FILL_PARENT,
				LayoutParams.FILL_PARENT);
		this.addContentView(circle, params);

		Message m = new Message();
		m.what = 0x101;
		myHandler.sendMessageDelayed(m, 500);
	}

	@Override
	public boolean onTouchEvent(MotionEvent event) {
		flagTouching = true;
		// TODO Auto-generated method stub
		int action = event.getActionMasked();
		// action point status
		int actionIndex = event.getActionIndex();
		// event的id直接對應到pointer的id
		int actionPointIndex = event.getPointerId(actionIndex);
		float actionPointX = event.getX(actionIndex);
		float actionPointY = event.getY(actionIndex);
		float actionPointPressure = event.getPressure(actionIndex);
		float actionPointSize = event.getSize(actionIndex);
		long time = System.currentTimeMillis();
		pointers = event.getPointerCount();

		switch (action) {
		// 更新pointer的內容
		case MotionEvent.ACTION_DOWN:

			pointer[actionPointIndex].touchDown(actionPointIndex, actionPointX,
					actionPointY, actionPointPressure, actionPointSize, time);

			break;
		case MotionEvent.ACTION_POINTER_DOWN:
			pointer[actionPointIndex].touchDown(actionPointIndex, actionPointX,
					actionPointY, actionPointPressure, actionPointSize, time);

			break;
		case MotionEvent.ACTION_POINTER_UP:
			pointer[actionPointIndex].touchUp();
			break;
		case MotionEvent.ACTION_UP:
			pointer[actionPointIndex].touchUp();
			break;
		default:
			for (int i = 0; i < event.getPointerCount(); ++i) {

				pointer[event.getPointerId(i)].touchDown(event.getPointerId(i),
						event.getX(i), event.getY(i), event.getPressure(i),
						event.getSize(i), time);
			}

			break;
		}

		// 重新繪圖
		circle.invalidate();
		return super.onTouchEvent(event);
	}

}