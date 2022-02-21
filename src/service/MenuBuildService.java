package service;

import java.util.ArrayList;
import java.util.List;

import model.Menu;

public class MenuBuildService {
	
	private List<Menu> menuList = new ArrayList<Menu>();
	
    public MenuBuildService(List<Menu> menuList) {
    	this.menuList = menuList;
    }

    //Establish tree structure
    public List<Menu> buildTree(){
        List<Menu> treeMenus = new ArrayList<Menu>();
        for(Menu menuNode : getRootNode()) {
            menuNode = buildChildTree(menuNode);
            treeMenus.add(menuNode);
        }
        return treeMenus;
    }

    //Recursion, building subtree structure
    private Menu buildChildTree(Menu pNode){
        List<Menu> chilMenus = new  ArrayList<Menu>();
        for(Menu menuNode : menuList) {
            if(menuNode.getParentMenuId().equals(pNode.getMenuId())) {
                chilMenus.add(buildChildTree(menuNode));
            }
        }
        pNode.setChildren(chilMenus);
        return pNode;
    }

    //Get root node
    private List<Menu> getRootNode() {
        List<Menu> rootMenuLists = new  ArrayList<Menu>();
        for(Menu menuNode : menuList) {
            if(menuNode.getParentMenuId().equals("0")) {
                rootMenuLists.add(menuNode);
            }
        }
        return rootMenuLists;
    }
}