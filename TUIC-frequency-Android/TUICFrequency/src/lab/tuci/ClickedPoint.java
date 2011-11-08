package lab.tuci;

import java.util.ArrayList;

import android.util.Log;

public class ClickedPoint {
	ArrayList<Pointer> list = new ArrayList<Pointer>();

	void add(Pointer inP) {

		if (list.size() == 0) {
			list.add(inP);
		} else {
			boolean flag = true;
			// �M�����n������
			long now = System.currentTimeMillis();
			while (flag) {
				flag = false;

				for (Pointer p : list) {
					if (now - p.startTime > 1000) {
						flag = true;
						list.remove(p);
						break;
					}

					if (((p.x - inP.x) * (p.x - inP.x) + (p.y - inP.y)
							* (p.y - inP.y)) < 500) {
						flag = true;
						list.remove(p);

						break;
					}
				}

			}
			// �N��}���I�[�J����
			list.add(inP);

		}

	}

	Pointer getPoint(float inX, float inY) {

		Pointer r = null;
		Long now = System.currentTimeMillis();
		for (Pointer p : list) {

			if (((p.x - inX) * (p.x - inX) + (p.y - inY) * (p.y - inY)) < 500
					&& now - p.startTime <= 500) {
				r = new Pointer(p);
				break;
			}
		}

		return r;
	}
}
