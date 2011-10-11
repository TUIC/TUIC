package lab.tuic;

import java.io.IOException;

import android.app.Activity;
import android.content.Context;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class TUICVolumeActivity extends Activity {
	/** Called when the activity is first created. */
	int preY = -1;
	int th = 15;
	private MediaPlayer mMedia;
	private AudioManager audioManager;
	Button startButton;
	Button stopButton;
	TextView volumnText;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
		mMedia = MediaPlayer.create(TUICVolumeActivity.this, R.raw.magnet);
		findView();
		setListener();
		volumnText.setText("Volumn:"
				+ audioManager.getStreamVolume(AudioManager.STREAM_MUSIC));
	}

	void findView() {
		startButton = (Button) findViewById(R.id.button1);
		stopButton = (Button) findViewById(R.id.button2);
		volumnText = (TextView) findViewById(R.id.textView1);
	}

	void setListener() {
		startButton.setOnClickListener(new Button.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

				if (mMedia.isPlaying()) {
					mMedia.pause();
				} else {
					mMedia.start();
				}
			}

		});
		stopButton.setOnClickListener(new Button.OnClickListener() {
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if (mMedia != null) {
					mMedia.stop();
					mMedia.reset();
				}
				mMedia = MediaPlayer.create(TUICVolumeActivity.this,
						R.raw.magnet);
				try {
					mMedia.prepare();
				} catch (IllegalStateException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				mMedia.start();
				mMedia.pause();

			}

		});
	}

	@Override
	public void onPause() {
		if (mMedia != null) {
			mMedia.stop();
			mMedia.reset();
		}
		super.onPause();
	}

	@Override
	public boolean onTouchEvent(MotionEvent e) {
		// Log.e("y", "" + e.getPointerCount());
		int y = (int) e.getY();
		if (e.getAction() == MotionEvent.ACTION_DOWN) {
			preY = y;
		}
		if (e.getAction() == MotionEvent.ACTION_MOVE) {
			if (inRange(e.getX(), e.getY())) {
				if (preY == -1 || y > 780 || y < 560) {
					preY = y;
				} else if (preY - y > th) {
					volume(true, preY, y);
					preY = y;
				} else if (preY - y < -th) {
					volume(false, preY, y);
					preY = y;
				}

			}

		}

		return true;
	}

	void volume(boolean up, int a, int b) {
		if (up) {
			Log.e("vol", "up " + a + " " + b);
			audioManager.adjustVolume(AudioManager.ADJUST_RAISE, 0);
			audioManager.adjustStreamVolume(AudioManager.STREAM_MUSIC,
					AudioManager.ADJUST_RAISE, 0);
		} else {
			Log.e("vol", "down " + a + " " + b);
			audioManager.adjustStreamVolume(AudioManager.STREAM_MUSIC,
					AudioManager.ADJUST_LOWER, 0);
		}
		volumnText.setText("Volumn:"
				+ audioManager.getStreamVolume(AudioManager.STREAM_MUSIC));
	}

	boolean inRange(float inX, float inY) {
		if (inX > 400 && inY > 550) {
			return true;
		}
		return false;
	}
}