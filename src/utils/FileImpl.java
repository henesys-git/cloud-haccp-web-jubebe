package utils;

public class FileImpl {
	private String path;
	
	public FileImpl(String path) {
		this.path = path;
	}
	
	boolean download() {
		return true;
	};

	boolean upload() {
		return true;
	};
	
	boolean isExist() {
		return true;
	};
	
	boolean delete() {
		return true;
	};
	
	String getName() {
		return "";
	};
	
	String getNameWithExtension() {
		return "";
	};
	
	String getExtension() {
		return "";
	};
	
	String getPath() {
		return "";
	};
}
