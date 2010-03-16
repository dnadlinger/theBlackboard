import at.klickverbot.theBlackboard.view.IDrawingAreaOverlay;
import at.klickverbot.event.events.ButtonEvent;
import at.klickverbot.event.events.Event;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.theBlackboard.view.theme.ContainerElement;
import at.klickverbot.theBlackboard.model.Entry;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.Spacer;
import at.klickverbot.ui.components.themed.Button;
import at.klickverbot.ui.components.themed.MultiContainer;
import at.klickverbot.ui.components.themed.TextBox;

class at.klickverbot.theBlackboard.view.EditEntryDetailsView
   extends CustomSizeableComponent implements IDrawingAreaOverlay {

   public function EditEntryDetailsView( model :Entry ) {
      super();

      m_model = model;

      m_editEntryDetailsContainer =
         new MultiContainer( AppClipId.EDIT_ENTRY_DETAILS_CONTAINER );

      m_detailsFormContainer =
         new MultiContainer( AppClipId.ENTRY_DETAILS_FORM_CONTAINER );

      m_authorText = new TextBox( AppClipId.DEFAULT_TEXT_BOX );
      m_detailsFormContainer.addContent(
         ContainerElement.DETAILS_FORM_AUTHOR, m_authorText );

      m_captionText = new TextBox( AppClipId.DEFAULT_TEXT_BOX );
      m_detailsFormContainer.addContent(
         ContainerElement.DETAILS_FORM_CAPTION, m_captionText );

      m_submitButton = new Button( AppClipId.NEXT_STEP_BUTTON );
      m_submitButton.oneShotMode = true;
      m_submitButton.addEventListener( ButtonEvent.PRESS, this, handleSubmitPress );
      m_detailsFormContainer.addContent(
         ContainerElement.DETAILS_FORM_SUBMIT, m_submitButton );

      m_editEntryDetailsContainer.addContent(
         ContainerElement.EDIT_DETAILS_FORM, m_detailsFormContainer );

      m_drawingAreaDummy = new Spacer( new Point2D( 1, 1 ) );
      m_editEntryDetailsContainer.addContent(
         ContainerElement.EDIT_DETAILS_DRARING_AREA, m_drawingAreaDummy );
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      if ( !m_editEntryDetailsContainer.create( m_container ) ) {
         super.destroy();
         return false;
      }

      m_authorText.text = ( m_model.author == null ) ? "" : m_model.author;
      m_captionText.text = ( m_model.author == null ) ? "" : m_model.author;

      updateSizeDummy();
      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         m_editEntryDetailsContainer.destroy();
      }
      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !checkOnStage( "resize" ) ) return;
      super.resize( width, height );

      m_editEntryDetailsContainer.resize( width, height );
   }

   private function handleSubmitPress( event :ButtonEvent ) :Void {
      // TODO: Validity checks here.
      m_model.author = m_authorText.text;
      m_model.caption = m_captionText.text;

      dispatchEvent( new Event( Event.COMPLETE, this ) );
   }

   public function getDrawingAreaPosition() :Point2D {
      return m_drawingAreaDummy.getGlobalPosition();
   }

   public function getDrawingAreaSize() :Point2D {
      return m_drawingAreaDummy.getSize();
   }

   private var m_model :Entry;

   private var m_editEntryDetailsContainer :MultiContainer;

   private var m_drawingAreaDummy :Spacer;

   private var m_detailsFormContainer :MultiContainer;
   private var m_authorText :TextBox;
   private var m_captionText :TextBox;
   private var m_submitButton :Button;
}
