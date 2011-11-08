package lab.tuci;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Paint.Style;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;

/**
 * 
 * @author linweidong
 * @date 2010-11-05
 */
public class Circle extends View {

	int showRGB = 0;
	Bitmap flagBitmap[];
	Bitmap background;
	boolean flagIsLighting = false;
	boolean flagLight = true;
	boolean flagDemoMode = true;
	float tri[][] = new float[3][2];
	float line[][] = new float[2][2];
	String name[][] = {
			{ "みずがめざ", "さかなざ", "おすひつじざ", "おうしざ", "てんびんざ", "いてざ", "ふたござ", "かにざ",
					"ししざ", "おとめざ", "さそりざ", "やぎざ" },
			{ "Aquarius", "Pisces", "Aries", "Taurus", "Libra", "Sagittarius",
					"Gemini", "Cancer", "Leo", "Virgo", "Scorpio", "Capricorn" },
			{ "水瓶座", "雙魚座", "牡羊座", "金牛座", "天秤座", "射手座", "雙子座", "巨蟹座", "獅子座",
					"處女座", "天蠍座", "魔羯座" } };
	int id = 0;
	float rx = 0;
	float ry = 0;
	int tapping = 0;

	public Circle(Context context) {
		super(context);
		background = BitmapFactory.decodeResource(getResources(),
				R.drawable.background);
		flagBitmap = new Bitmap[3];
		flagBitmap[0] = BitmapFactory.decodeResource(getResources(),
				R.drawable.flag1);
		flagBitmap[1] = BitmapFactory.decodeResource(getResources(),
				R.drawable.flag2);
		flagBitmap[2] = BitmapFactory.decodeResource(getResources(),
				R.drawable.flag3);

	}

	public Circle(Context context, AttributeSet attrs) {
		super(context, attrs);
		// TODO Auto-generated constructor stub

		background = BitmapFactory.decodeResource(getResources(),
				R.drawable.background);
		flagBitmap = new Bitmap[3];
		flagBitmap[0] = BitmapFactory.decodeResource(getResources(),
				R.drawable.flag1);
		flagBitmap[1] = BitmapFactory.decodeResource(getResources(),
				R.drawable.flag2);
		flagBitmap[2] = BitmapFactory.decodeResource(getResources(),
				R.drawable.flag3);
	}

	@Override
	protected void onDraw(Canvas canvas) {
		// TODO Auto-generated method stub
		canvas.drawBitmap(background, 0, 0, null);
		if (flagIsLighting) {
			// Log.e("c", "draw");
			Paint l = new Paint();
			if (flagLight) {

				l.setColor(Color.BLACK);
			} else {

				l.setColor(Color.WHITE);
			}

			canvas.drawCircle((tri[0][0] + tri[1][0] + tri[2][0]) / 3.f,
					(tri[0][1] + tri[1][1] + tri[2][1]) / 3.f, 75, l);

		}

		// if (tapping == 2) {
		// // Log.e("c", "draw");
		// Paint l = new Paint();
		// if (showRGB == 3) {
		// l.setColor(Color.BLACK);
		// }
		//
		// else if (showRGB == 4) {
		// l.setColor(Color.BLUE);
		// } else if (showRGB == 5) {
		// l.setColor(Color.YELLOW);
		// } else {
		// l.setColor(Color.GREEN);
		// }
		// float x = 0;
		// float y = 0;
		// for (int i = 0; i < 3; i++) {
		//
		// // if (i != id) {
		// if (tri[i][0] > x) {
		// x = tri[i][0];
		// y = tri[i][1];
		// }
		//
		// // }
		// }
		// canvas.drawCircle(x + 100, y, 50, l);
		// l.setTextSize(40);
		// Log.e("xy", x + " " + y);
		// if (y < 250) {
		// canvas.drawText(showRGB + " " + (int) ((x - 100) / 200 + 1)
		// + " ", x + 50, y + 100, l);
		// } else if (y > 350) {
		// canvas.drawText(showRGB + " "
		// + (int) (((x - 100) / 200 + 1) + 6) + " ", x + 50,
		// y + 100, l);
		// }
		// }
		if (flagDemoMode) {
			// else {
			long time = System.currentTimeMillis();
			// canvas.drawColor(Color.rgb(showRGB, showRGB, showRGB));

			if (showRGB >= 6 && showRGB <= 10) {
				// canvas.drawBitmap(gBitmap[showRGB - 6], 0, 0, new Paint());

				Paint t = new Paint();
				t.setColor(Color.RED);
				t.setTextSize(48);
				canvas.drawText("" + (showRGB - 5), 100, 150, t);
			} else {
				// canvas.drawColor(Color.BLACK);
			}

			int cnt = 0;
			int e = 0;
			rx = 0;
			ry = 0;
			for (int i = 0; i < 10; i++) {
				Pointer p = TUICFrequencyActivity.pointer[i];

				if (p.exist) {
					e++;
					// if (p.clickCnt > cnt) {
					// if (p.showHz != 0) {
					// cnt = p.clickCnt;
					// showRGB = p.showHz;// * 30 - 100;
					// if (showRGB > 250) {
					// showRGB = 250;
					// }
					// }
					//
					// }
					Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
					if (p.pressure > 1) {
						paint.setColor(Color.RED);
					} else {
						paint.setColor(Color.rgb(255,
								255 - (int) (255 * p.pressure),
								255 - (int) (255 * p.pressure)));
					}
					paint.setAntiAlias(true);
					paint.setStyle(Style.FILL);

					canvas.drawCircle(p.x, p.y, 30.0f + 30.0f * p.size, paint);
					if (p.x > rx) {
						rx = p.x;
						ry = p.y;
					}
					paint.setColor(Color.BLACK);
					paint.setTextSize(24);

					if (time != p.startTime) {
						canvas.drawText(p.clickCnt + "=>" + p.nowHz, p.x, p.y,
								paint);
					}
				}
			}
		}
		if (tapping == 2) {
			// Log.e("c", "draw");
			Paint l = new Paint();
			l.setTextSize(40);
			l.setColor(Color.RED);
			int x = ((int) ((rx - 100) / 200)) % 6;
			if (ry > 350 && ry < 600) {
				x += 6;
			}
			if (showRGB == 3) {
				canvas.drawBitmap(flagBitmap[0], rx + 100, ry-50, null);
				canvas.drawText(name[0][x], rx + 100, ry + 150, l);
			}

			else if (showRGB == 4) {
				canvas.drawBitmap(flagBitmap[1], rx + 100, ry-50, null);
				canvas.drawText(name[1][x], rx + 100, ry + 150, l);
			} else {
				canvas.drawBitmap(flagBitmap[2], rx + 100, ry-50, null);
				canvas.drawText(name[2][x], rx + 100, ry + 150, l);
			}

			// canvas.drawCircle(rx + 100, ry, 50, l);

//			Log.e("xy", rx + " " + ry);

		}
		// Log.e("cir",e+"");
		// if (e == 3) {
		// for (int i = 0; i < 10; i++) {
		// Pointer p = TUICFrequencyActivity.pointer[i];
		// if (p.exist) {
		// if (e >= 0) {
		// e--;
		// tri[e][0] = p.x;
		// tri[e][1] = p.y;
		// Log.e("cir", tri[e][0] + " " + tri[e][1]);
		// }
		// }
		// }
		// }
		// }
		super.onDraw(canvas);

	}

}