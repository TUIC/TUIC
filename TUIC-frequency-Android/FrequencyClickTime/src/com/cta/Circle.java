package com.cta;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Paint.Style;
import android.util.AttributeSet;
import android.view.View;

/**
 * 
 * @author linweidong
 * @date 2010-11-05
 */
public class Circle extends View {

	int showRGB = 0;
	Bitmap gBitmap[];

	public Circle(Context context) {
		super(context);
		gBitmap = new Bitmap[5];
		gBitmap[0] = BitmapFactory
				.decodeResource(getResources(), R.drawable.g1);
		gBitmap[1] = BitmapFactory
				.decodeResource(getResources(), R.drawable.g2);
		gBitmap[2] = BitmapFactory
				.decodeResource(getResources(), R.drawable.g3);
		gBitmap[3] = BitmapFactory
				.decodeResource(getResources(), R.drawable.g4);
		gBitmap[4] = BitmapFactory
				.decodeResource(getResources(), R.drawable.g5);
		// TODO Auto-generated constructor stub
	}

	public Circle(Context context, AttributeSet attrs) {
		super(context, attrs);
		// TODO Auto-generated constructor stub

		gBitmap = new Bitmap[5];
		gBitmap[0] = BitmapFactory
				.decodeResource(getResources(), R.drawable.g1);
		gBitmap[1] = BitmapFactory
				.decodeResource(getResources(), R.drawable.g2);
		gBitmap[2] = BitmapFactory
				.decodeResource(getResources(), R.drawable.g3);
		gBitmap[3] = BitmapFactory
				.decodeResource(getResources(), R.drawable.g4);
		gBitmap[4] = BitmapFactory
				.decodeResource(getResources(), R.drawable.g5);
	}

	@Override
	protected void onDraw(Canvas canvas) {
		// TODO Auto-generated method stub
		long time = System.currentTimeMillis();
		// canvas.drawColor(Color.rgb(showRGB, showRGB, showRGB));

		if (showRGB >= 6 && showRGB <= 10) {
			canvas.drawBitmap(gBitmap[showRGB - 6], 0, 0, new Paint());
			Paint t = new Paint();
			t.setColor(Color.RED);
			t.setTextSize(48);
			canvas.drawText("" + (showRGB - 5), 100, 100, t);
		} else {
			canvas.drawColor(Color.BLACK);
		}

		int cnt = 0;
		for (int i = 0; i < 10; i++) {
			Pointer p = FrequencyClickTime.pointer[i];

			if (p.exist) {
				if (p.clickCnt > cnt) {
					if (p.showHz != 0) {
						cnt = p.clickCnt;
						showRGB = p.showHz;// * 30 - 100;
						if (showRGB > 250) {
							showRGB = 250;
						}
					}

				}
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

				paint.setColor(Color.WHITE);
				paint.setTextSize(24);
				// ¦L¥X
				if (time != p.startTime) {
					canvas.drawText(p.clickCnt + "=>" + p.nowHz, p.x, p.y,
							paint);
				}
			}
		}

		super.onDraw(canvas);

	}

}