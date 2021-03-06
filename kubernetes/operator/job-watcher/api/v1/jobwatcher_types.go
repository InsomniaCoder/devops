/*
Copyright 2021.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package v1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.

// JobWatcherSpec defines the desired state of JobWatcher
type JobWatcherSpec struct {
	// INSERT ADDITIONAL SPEC FIELDS - desired state of cluster
	// Important: Run "make" to regenerate code after modifying this file

	// +kubebuilder:validation:Minimum=0
	// Time to live in seconds for a completed job
	CompletedTTL int64 `json:"completedTTL"`

	// +kubebuilder:validation:Minimum=0
	// Time to live in seconds for a failed job
	FailedTTL int64 `json:"failedTTL"`

	// +optional
	// +kubebuilder:validation:MinItems=0
	// List of namespaces to watch
	NamespacePatterns []string `json:"namespaces,omitempty"`

	// +optional
	// +kubebuilder:validation:MinItems=0
	// Job name pattern to watch
	JobNamePatterns []string `json:"jobNames,omitempty"`

	// +kubebuilder:validation:Minimum=10
	// Frequency of the TTL checks
	Frequency int64 `json:"frequency"`
}

// JobWatcherStatus defines the observed state of JobWatcher
type JobWatcherStatus struct {
	// INSERT ADDITIONAL STATUS FIELD - define observed state of cluster
	// Important: Run "make" to regenerate code after modifying this file

	LastStarted  metav1.Time `json:"lastStarted,omitempty"`
	LastFinished metav1.Time `json:"lastFinished,omitempty"`
}

//+kubebuilder:object:root=true
//+kubebuilder:subresource:status

// JobWatcher is the Schema for the jobwatchers API
type JobWatcher struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   JobWatcherSpec   `json:"spec,omitempty"`
	Status JobWatcherStatus `json:"status,omitempty"`
}

//+kubebuilder:object:root=true

// JobWatcherList contains a list of JobWatcher
type JobWatcherList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []JobWatcher `json:"items"`
}

func init() {
	SchemeBuilder.Register(&JobWatcher{}, &JobWatcherList{})
}
