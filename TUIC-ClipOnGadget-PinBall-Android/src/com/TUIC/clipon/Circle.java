package com.TUIC.clipon;

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
	public void onDraw(Canvas canvas) {
		// TODO Auto-generated method stub
		Launcher launcher=CliponActivity.launcher;
		Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
	
		paint.setColor(Color.RED);
	
		paint.setAntiAlias(true);
		paint.setStyle(Style.FILL);
		
		Paint paint2=new Paint();
		paint2.setColor(Color.WHITE);
		paint2.setTextSize(24);
		for(int i=0;i<CliponActivity.ballCount;i++){
			Ball ball= CliponActivity.ball[i];	
			canvas.drawCircle(ball.x, ball.y,ball.size, paint);

//			canvas.drawText((int)ball.vx+" "+(int)ball.vy,ball.x,ball.y,paint2);
		}
		
		for(int i = 0;i<22;i++){
			Pin pin= CliponActivity.pin[i];	
			canvas.drawCircle(pin.x, pin.y,10, paint2);

		}

			canvas.drawCircle(launcher.x, launcher.y,launcher.size, paint);
			//canvas.drawCircle(p.x, p.y-80.0f, -10.0f+ 100.0f * p.size, paint);
	
		
		
//
//		super.onDraw(canvas);

	}

}