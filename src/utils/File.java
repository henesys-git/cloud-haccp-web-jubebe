package utils;

public interface File {
	boolean download();
	
	boolean upload();
	
	boolean isExist();
	
	boolean delete();
	
	String getName();
	
	String getNameWithExtension();
	
	String getExtension();
	
	String getPath();
}