/*
* Copyright 2007-2011 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.as3commons.metadata.registry.impl {

	import flash.system.ApplicationDomain;

	import org.as3commons.metadata.process.IMetadataProcessor;
	import org.as3commons.metadata.registry.IMetadataProcessorRegistry;
	import org.as3commons.reflect.IMetadataContainer;
	import org.as3commons.reflect.Type;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class AS3ReflectMetadataProcessorRegistry extends AbstractMetadataProcessorRegistry {

		/**
		 * Creates a new <code>AS3ReflectMetadataProcessorRegistry</code> instance.
		 */
		public function AS3ReflectMetadataProcessorRegistry() {
			super();
		}

		/**
		 *
		 * @param target
		 * @return
		 */
		override public function process(target:Object):* {
			var type:Type = Type.forInstance(target, applicationDomain);
			processType(type, target);
		}

		/**
		 *
		 * @param type
		 * @param target
		 */
		protected function processType(type:Type, target:Object):void {
			for (var name:String in metadataLookup) {
				var processors:Vector.<IMetadataProcessor> = metadataLookup[name] as Vector.<IMetadataProcessor>;
				var containers:Array = (type.hasMetadata(name)) ? [type] : [];
				var memberContainers:Array = type.getMetadataContainers(name);
				if (memberContainers != null) {
					containers = containers.concat(memberContainers);
				}

				for each (var container:IMetadataContainer in containers) {
					for each (var processor:IMetadataProcessor in processors) {
						processor.process(target, name, container);
					}
				}
			}

		}

	}
}
