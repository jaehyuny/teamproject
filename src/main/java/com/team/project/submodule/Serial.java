package com.team.project.submodule;

import gnu.io.CommPort;
import gnu.io.CommPortIdentifier;
import gnu.io.SerialPort;
import lombok.Data;

import java.io.FileDescriptor;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.springframework.stereotype.Component;

@Data
@Component
public class Serial {	
	Thread thread;
	public Serial() {
		super();
	}

	public void connect() throws Exception {
		CommPortIdentifier portIdentifier = CommPortIdentifier.getPortIdentifier("COM3");
		if (portIdentifier.isCurrentlyOwned()) {
			System.out.println("Error: Port is currently in use");			
		} else {
			// 클래스 이름을 식별자로 사용하여 포트 오픈
			CommPort commPort = portIdentifier.open(this.getClass().getName(), 2000);

			if (commPort instanceof SerialPort) {
				// 포트 설정(통신속도 설정. 기본 9600으로 사용)
				SerialPort serialPort = (SerialPort) commPort;
				serialPort.setSerialPortParams(9600, SerialPort.DATABITS_8, SerialPort.STOPBITS_1,
						SerialPort.PARITY_NONE);

				// Input 버퍼 생성 후 오픈
				InputStream in = serialPort.getInputStream();
				

				// 읽기 쓰레드 작동				
				thread = (new Thread(new SerialReader(in)));
				thread.start();

			} else {
				System.out.println("Error: Only serial ports are handled by this example.");
			}
		}		
	}

	/** */
	// 데이터 수신
	public class SerialReader implements Runnable {
		InputStream in;

		public SerialReader(InputStream in) {
			this.in = in;
		}

		public void run() {
			byte[] buffer = new byte[1024];
			int len = -1;
			try {
				while ((len = this.in.read(buffer)) > -1) {					
					System.out.print((new String(buffer, 0, len)));
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
}