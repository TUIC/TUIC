package com.mr;

import android.app.Activity;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup.LayoutParams;

public class MyRowData extends Activity implements Runnable {
	/** Called when the activity is first created. */
	long time;
	static Pointer pointer[];
	static Pointer clicked[];
	static ClickedPoint cp;
	View circle;
	int pointers;

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
		// 開啓thread
		(new Thread(this)).start();

	}

	@Override
	public boolean onTouchEvent(MotionEvent event) {
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

	@Override
	public void run() {
		// TODO Auto-generated method stub
		while (true) {
			try {
				// 更新各pointer的頻率
				for (int i = 0; i < 10; i++) {

					pointer[i].hz = pointer[i].clickCnt - pointer[i].clickPre;
					pointer[i].clickPre = pointer[i].clickCnt;

				}
				Thread.sleep(1000);

			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

	}
}