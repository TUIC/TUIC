package com.cta;

import android.content.Context;
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
	public Circle(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
	}

	public Circle(Context context, AttributeSet attrs) {
		super(context, attrs);
		// TODO Auto-generated constructor stub
	}

	@Override
	protected void onDraw(Canvas canvas) {
		// TODO Auto-generated method stub
		long time = System.currentTimeMillis();
		for (int i = 0; i < 10; i++) {
			Pointer p = FrequencyClickTime.pointer[i];
			if (p.exist) {
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

				// ¦L¥X
				if (time != p.startTime)
					canvas.drawText(p.clickCnt + "=>" + p.hz, p.x, p.y, paint);
			}
		}

		super.onDraw(canvas);

	}

}