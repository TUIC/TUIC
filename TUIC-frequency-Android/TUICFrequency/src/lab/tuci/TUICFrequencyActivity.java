package lab.tuci;

import android.app.Activity;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Paint.Style;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup.LayoutParams;

public class TUICFrequencyActivity extends Activity {
	/** Called when the activity is first created. */
	// 用來處理沒touch時將畫面清空
	Handler myHandler = new Handler() {
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case 0x101:
				if (flagTouching) {
					flagTouching = false;
				} else {
					if (((Circle) circle).tapping == 1) {
						((Circle) circle).tapping = 2;
						// Log.e("rgb", (rgb - 5) + "");
						// if (rgb < 8) {
						// rgb = 8;
						// }
						// ((Circle) circle).showRGB = rgb - 5;

						((Circle) circle).flagIsLighting = false;
						flagIsLighting = false;
						// Log.e("tap2", ((Circle) circle).tapping + "");
					}
					circle.invalidate();
				}
				Message m = new Message();
				m.what = 0x101;
				this.sendMessageDelayed(m, 500);
				// Log.e("rgb", rgb + "");
				break;

			case 0x102:
				if (flagIsLighting) {
					((Circle) circle).flagIsLighting = true;
					((Circle) circle).flagLight = !((Circle) circle).flagLight;
					circle.invalidate();
					Message ms = new Message();
					ms.what = 0x102;
					myHandler.sendMessageDelayed(ms, 240);
				}
				break;
			}

		}
	};

	/** Called when the activity is first created. */
	long time;
	static Pointer pointer[];
	static Pointer clicked[];
	int id = 0;
	int rgb = 100;
	static ClickedPoint cp;
	View circle;
	int pointers;
	boolean flagTouching = false;
	boolean flagIsLighting = false;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		// setContentView(R.layout.main);

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
			flagTouching = true;
			pointer[actionPointIndex].touchDown(actionPointIndex, actionPointX,
					actionPointY, actionPointPressure, actionPointSize, time);

			break;
		case MotionEvent.ACTION_POINTER_DOWN:
			flagTouching = true;
			pointer[actionPointIndex].touchDown(actionPointIndex, actionPointX,
					actionPointY, actionPointPressure, actionPointSize, time);

			break;
		case MotionEvent.ACTION_POINTER_UP:
			pointer[actionPointIndex].touchUp();
			break;
		case MotionEvent.ACTION_UP:
			pointer[actionPointIndex].touchUp();
			((Circle) circle).tapping = 0;
			rgb = 100;
			((Circle) circle).flagIsLighting = false;
			flagIsLighting = false;
			// Log.e("tap0", ((Circle) circle).tapping + "");
			break;
		default:
			for (int i = 0; i < event.getPointerCount(); ++i) {

				pointer[event.getPointerId(i)].touchDown(event.getPointerId(i),
						event.getX(i), event.getY(i), event.getPressure(i),
						event.getSize(i), time);

				int hz = 100;
				int e = 0;

				for (int j = 0; j < 10; j++) {

					if (pointer[j].exist) {

						if (hz > pointer[j].showHz && pointer[j].showHz != 0) {
							hz = pointer[j].showHz;
							rgb = hz;
							((Circle) circle).id = e;
							id = j;
						}
						e++;
					}

				}
				// if (rgb > hz) {
				//
				// rgb = hz;
				// }
				if (e == 2 || e == 3) {
					int k = 0;
					for (int j = 0; j < 10; j++) {
						if (pointer[j].exist) {
							if (j != id) {
								((Circle) circle).tri[k][0] = pointer[j].x;
								((Circle) circle).tri[k][1] = pointer[j].y;
							}
							k++;
						}
					}
				}
				int k = 0;
				if (hz >= 6 && hz <= 10) {
					((Circle) circle).tapping = 1;
					// Log.e("tap1", ((Circle) circle).tapping + "");
					for (int j = 0; j < 10; j++) {

						pointer[j].hzCnt = 0;
						pointer[j].showHz = 0;
					}
					if (flagIsLighting == false) {
						// Log.e("fa", hz + " " + flagIsLighting);
						Log.e("rgb", (hz - 5) + "");
						flagIsLighting = true;
						((Circle) circle).showRGB = hz - 5;
						// Log.e("fa", "" + flagIsLighting);
						myHandler.sendEmptyMessage(0x102);

					}
				}

			}

			break;
		}

		// 重新繪圖
		circle.invalidate();
		return super.onTouchEvent(event);
	}

}