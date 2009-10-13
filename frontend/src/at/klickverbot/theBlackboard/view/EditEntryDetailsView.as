import at.klickverbot.debug.Debug;
import at.klickverbot.event.events.ButtonEvent;
import at.klickverbot.theBlackboard.control.SaveEntryEvent;
import at.klickverbot.theBlackboard.model.Model;
import at.klickverbot.theBlackboard.view.DrawingAreaContainer;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.theBlackboard.view.theme.ContainerElement;
import at.klickverbot.theBlackboard.vo.Entry;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.themed.Button;
import at.klickverbot.ui.components.themed.MultiContainer;
import at.klickverbot.ui.components.themed.TextBox;

class at.klickverbot.theBlackboard.view.EditEntryDetailsView extends CustomSizeableComponent
   implements IUiComponent {

   public function EditEntryDetailsView() {
      super();

      m_editEntryDetailsContainer =
         new MultiContainer( AppClipId.EDIT_ENTRY_DETAILS_CONTAINER );

      m_drawingAreaContainer = new DrawingAreaContainer();
      m_editEntryDetailsContainer.addContent(
         ContainerElement.EDIT_DETAILS_DRARING_AREA, m_drawingAreaContainer );

      m_detailsFormContainer =
         new MultiContainer( AppClipId.ENTRY_DETAILS_FORM_CONTAINER );

      m_authorText = new TextBox( AppClipId.DEFAULT_TEXT_BOX );
      m_detailsFormContainer.addContent(
         ContainerElement.DETAILS_FORM_AUTHOR, m_authorText );

      m_captionText = new TextBox( AppClipId.DEFAULT_TEXT_BOX );
      m_detailsFormContainer.addContent(
         ContainerElement.DETAILS_FORM_CAPTION, m_captionText );

      m_submitButton = new Button( AppClipId.NEXT_STEP_BUTTON );
      m_submitButton.addEventListener( ButtonEvent.PRESS, this, handleSubmitPress );
      m_detailsFormContainer.addContent(
         ContainerElement.DETAILS_FORM_SUBMIT, m_submitButton );

      m_editEntryDetailsContainer.addContent(
         ContainerElement.EDIT_DETAILS_FORM, m_detailsFormContainer );
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      if ( !m_editEntryDetailsContainer.create( m_container ) ) {
         super.destroy();
         return false;
      }

      // Use the values currently in the selected entry as defaults.
      var entry :Entry = Model.getInstance().selectedEntry;

      m_drawingAreaContainer.getDrawingArea().loadDrawing( entry.drawing );

      m_authorText.text = entry.author;
      m_captionText.text = entry.caption;

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
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn(
            "Attempted to resize a component that is not stage: " + this );
         return;
      }

      super.resize( width, height );
      m_editEntryDetailsContainer.resize( width, height );
   }

   private function handleSubmitPress( event :ButtonEvent ) :Void {
      // TODO: Validity checks here.
      var entry :Entry = Model.getInstance().selectedEntry;
      entry.author = m_authorText.text;
      entry.caption = m_captionText.text;

      ( new SaveEntryEvent( entry ) ).dispatch();
   }

   private var m_editEntryDetailsContainer :MultiContainer;
   private var m_drawingAreaContainer :DrawingAreaContainer;
   private var m_detailsFormContainer :MultiContainer;

   private var m_authorText :TextBox;
   private var m_captionText :TextBox;
   private var m_submitButton :Button;
}
