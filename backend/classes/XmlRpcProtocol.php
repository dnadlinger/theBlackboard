<?php
class XmlRpcProtocol implements IProtocol {
	public function createRequest() {
		return new XmlRpcRequest();
	}

	public function createResponse() {
		return new XmlRpcResponse();
	}
}
?>