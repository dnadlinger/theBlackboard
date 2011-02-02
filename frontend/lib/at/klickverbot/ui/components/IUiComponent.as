import at.klickverbot.event.IEventDispatcher;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.graphics.Tint;

/**
 * Represents a visible user interface component that can be created in a
 * target MovieClip, destroyed, hidden, and moved around the stage.
 */
interface at.klickverbot.ui.components.IUiComponent extends IEventDispatcher {
   /**
    * Creates the visible part of the component in the target parent MovieClip.
    * The component can be recreated using {@link #destroy} and this function,
    * but only one (visible) representation can exist at the same time.
    *
    * @see #isOnStage
    * @param target The MovieClip where the component is created.
    * @param depth The depth in the MovieClip to create the component at.
    *        If null, the next highest availible depth is used.
    * @return If the component could be created.
    */
   public function create( target :MovieClip, depth :Number ) :Boolean;

   /**
    * Destroys the visible part of the component.
    * It can be recreated using {@link #create}.
    *
    * @see #isOnStage
    */
   public function destroy() :Void;

   /**
    * Returns whether the visible repesentation of the component is on stage.
    *
    * @see #create
    * @see #destroy
    * @return If the component is on stage.
    */
   public function isOnStage() :Boolean;

   /**
    * Moves the component to the specified position in its parent's coordinate
    * system.
    *
    * @see #moveToPoint
    * @see #getPosition
    * @param x The x-coordinate of the new position.
    * @param y The y-coordinate of the new position.
    */
   public function move( x :Number, y :Number ) :Void;

   /**
    * Moves the component to the specified position in its parent's coordinate
    * system.
    *
    * @see #move
    * @see #getPosition
    * @param newPosition A Point2D containing the new position in the parent's
    *        coordinate system.
    */
   public function setPosition( newPosition :Point2D ) :Void;

   /**
    * Returns the component's current position (if on stage).
    *
    * @see #getGlobalPosition
    * @return A Point2D containing the current position in the parent
    *         MovieClip's coordinate system.
    */
   public function getPosition() :Point2D;

   /**
    * Returns the component's current position in the global (stage) coordinate
    * system.
    * Of course, this only works if the component is currently on stage.
    *
    * @see #getPosition
    * @return A Point2D containing the current position in the stage coordinate
    *         system.
    */
   public function getGlobalPosition() :Point2D;

   /**
    * Resizes the component to the specified size.
    *
    * Some components could just scale their content, others could adjust their
    * layout, etc.
    *
    * @see #scale
    * @see #setSize
    * @see #getSize
    * @param width The width of the component, measured in the coordinate
    *        system of its parent.
    * @param height The height of the component, measured in the coordinate
    *        system of its parent.
    */
   public function resize( width :Number, height :Number ) :Void;

   /**
    * Scales the component according to the given factors.
    * Same as {@link #resize}, but uses scale factors instead of absoulte
    * values for width and height.
    *
    * @see #resize
    * @see #setSize
    * @see #getSize
    * @param xScaleFactor The factor to scale the component along the x-axis.
    * @param yScaleFactor The factor to scale the component along the y-axis.
    */
   public function scale( xScaleFactor :Number, yScaleFactor :Number ) :Void;

   /**
    * Returns a Point2D that contains the distance from its position to the
    * bottom right corner of its bounding box in its parent's coordinate system.
    * Can also be understood as the size where point.x is the width and point.y
    * is the height.
    *
    * @see #resize
    * @see #scale
    * @return A Point2D (would be better called Vector2D) that contains the
    *         component's size on stage.
    */
   public function getSize() :Point2D;

   /**
    * Resizes the component to the specified size.
    * Same as <code>#resize()</code>, but accepts a Point2D instead of discrete
    * components.
    *
    * @see #resize
    * @see #scale
    * @see #getSize
    * @param size A Point2D representing the new size for the component.
    */
   public function setSize( size :Point2D ) :Void;

   /**
    * Sets the component's translucency.
    *
    * Note that some components could be not fadeable, then they are completely
    * opaque if alpha > 0.
    *
    * @see #getAlpha
    *
    * @param alpha A value from 0-1 specifying the new translucency
    *        (1 is completely opaque).
    */
   public function fade( alpha :Number ) :Void;

   /**
    * Returns the translucency of the component.
    *
    * @see #fade
    *
    * @return The translucency of the component (0..1).
    */
   public function getAlpha() :Number;

   /**
    * Tints the component in the specified tone.
    *
    * @see #getTint
    *
    * @param tint The tint to apply.
    */
   public function tint( tint :Tint ) :Void;

   /**
    * Returns the currently applied tint.
    *
    * Note: There may be cases where the result can't be determined unambigously,
    * for instance when the tint amount is zero.
    *
    * @see #tint
    */
   public function getTint() :Tint;
}
