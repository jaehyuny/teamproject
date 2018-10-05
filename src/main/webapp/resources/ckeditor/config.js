/**
 * @license Copyright (c) 2003-2018, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see https://ckeditor.com/legal/ckeditor-oss-license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	config.toolbarGroups = [
		{ name: 'styles', groups: [ 'styles' ] },
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
		{ name: 'colors', groups: [ 'colors' ] },
		{ name: 'paragraph', groups: [ 'list', 'blocks', 'align', 'indent', 'bidi', 'paragraph' ] },
		{ name: 'clipboard', groups: [ 'clipboard', 'undo' ] },
		{ name: 'links', groups: [ 'links' ] },
		{ name: 'insert', groups: [ 'insert' ] }
	];
	config.removeButtons = 'Cut,Copy,Paste,PasteText,PasteFromWord,Replace,CopyFormatting,RemoveFormat,Subscript,Superscript,NumberedList,BulletedList,Blockquote,CreateDiv,BidiLtr,BidiRtl,Language,Unlink,Anchor,Flash,PageBreak,Iframe,Styles,Format';

	config.language = 'ko';
    config.uiColor = '#FCE4C5';
    config.font_names = '맑은 고딕; 돋움; 바탕; 돋음; 궁서; Nanum Gothic Coding; Quattrocento Sans;' + CKEDITOR.config.font_names; 
    config.height = '400px';  //Editor 높이  
    config.width = '100%';
    config.enterMode =CKEDITOR.ENTER_BR;
    config.toolbarCanCollapse = true;
    config.docType = "<!DOCTYPE html>";
    config.filebrowserFlashUploadUrl = 'imageUpload';
    config.filebrowserImageUploadUrl = 'imageUpload'; //여기 경로로 파일을 전달하여 업로드 시킨다.
    config.removePlugins = 'save'
};
